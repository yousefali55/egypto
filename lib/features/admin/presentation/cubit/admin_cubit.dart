import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/admin/data/models/admin_identity_details.dart';
import 'package:egypto/features/admin/data/models/admin_pending_page.dart';
import 'package:egypto/features/admin/data/repository/admin_repo.dart';

class AdminState {
  const AdminState({
    this.identityPage,
    this.propertiesPage,
    this.identityLoading = false,
    this.propertiesLoading = false,
    this.identityError,
    this.propertiesError,
    this.detail,
    this.identityDetails,
    this.detailLoading = false,
    this.detailError,
    this.processing = false,
    this.actionError,
    this.payments = const [],
    this.paymentsLoading = false,
    this.paymentsError,
    this.paymentDetail,
    this.paymentDetailLoading = false,
    this.paymentDetailError,
  });

  final AdminPendingPage? identityPage;
  final AdminPendingPage? propertiesPage;
  final bool identityLoading;
  final bool propertiesLoading;
  final AppErrorType? identityError;
  final AppErrorType? propertiesError;
  final Map<String, dynamic>? detail;
  final AdminIdentityDetails? identityDetails;
  final bool detailLoading;
  final AppErrorType? detailError;
  final bool processing;
  final AppErrorType? actionError;
  final List<Map<String, dynamic>> payments;
  final bool paymentsLoading;
  final AppErrorType? paymentsError;
  final Map<String, dynamic>? paymentDetail;
  final bool paymentDetailLoading;
  final AppErrorType? paymentDetailError;

  AdminState copyWith({
    AdminPendingPage? identityPage,
    AdminPendingPage? propertiesPage,
    bool? identityLoading,
    bool? propertiesLoading,
    AppErrorType? identityError,
    bool clearIdentityError = false,
    AppErrorType? propertiesError,
    bool clearPropertiesError = false,
    Map<String, dynamic>? detail,
    bool clearDetail = false,
    AdminIdentityDetails? identityDetails,
    bool clearIdentityDetails = false,
    bool? detailLoading,
    AppErrorType? detailError,
    bool clearDetailError = false,
    bool? processing,
    AppErrorType? actionError,
    bool clearActionError = false,
    List<Map<String, dynamic>>? payments,
    bool? paymentsLoading,
    AppErrorType? paymentsError,
    bool clearPaymentsError = false,
    Map<String, dynamic>? paymentDetail,
    bool clearPaymentDetail = false,
    bool? paymentDetailLoading,
    AppErrorType? paymentDetailError,
    bool clearPaymentDetailError = false,
  }) => AdminState(
    identityPage: identityPage ?? this.identityPage,
    propertiesPage: propertiesPage ?? this.propertiesPage,
    identityLoading: identityLoading ?? this.identityLoading,
    propertiesLoading: propertiesLoading ?? this.propertiesLoading,
    identityError: clearIdentityError
        ? null
        : identityError ?? this.identityError,
    propertiesError: clearPropertiesError
        ? null
        : propertiesError ?? this.propertiesError,
    detail: clearDetail ? null : detail ?? this.detail,
    identityDetails: clearIdentityDetails
        ? null
        : identityDetails ?? this.identityDetails,
    detailLoading: detailLoading ?? this.detailLoading,
    detailError: clearDetailError ? null : detailError ?? this.detailError,
    processing: processing ?? this.processing,
    actionError: clearActionError ? null : actionError ?? this.actionError,
    payments: payments ?? this.payments,
    paymentsLoading: paymentsLoading ?? this.paymentsLoading,
    paymentsError: clearPaymentsError
        ? null
        : paymentsError ?? this.paymentsError,
    paymentDetail: clearPaymentDetail ? null : paymentDetail ?? this.paymentDetail,
    paymentDetailLoading: paymentDetailLoading ?? this.paymentDetailLoading,
    paymentDetailError: clearPaymentDetailError
        ? null
        : paymentDetailError ?? this.paymentDetailError,
  );
}

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._repository) : super(const AdminState());

  static const int pageSize = 20;
  final AdminRepo _repository;

  Future<void> loadPendingPayments() async {
    if (state.paymentsLoading) return;
    emit(state.copyWith(paymentsLoading: true, clearPaymentsError: true));
    try {
      final payments = await _repository.getPendingPayments();
      emit(
        state.copyWith(
          payments: payments,
          paymentsLoading: false,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          paymentsLoading: false,
          paymentsError: _errorType(error),
        ),
      );
    }
  }

  Future<void> loadPaymentReceipt(String bookingId) async {
    emit(
      state.copyWith(
        paymentDetailLoading: true,
        clearPaymentDetail: true,
        clearPaymentDetailError: true,
      ),
    );
    try {
      final detail = await _repository.getPaymentReceipt(bookingId);
      emit(state.copyWith(paymentDetail: detail, paymentDetailLoading: false));
    } on Object catch (error) {
      emit(
        state.copyWith(
          paymentDetailLoading: false,
          paymentDetailError: _errorType(error),
        ),
      );
    }
  }

  Future<Uint8List> loadPaymentReceiptImage(String path) =>
      _repository.getPaymentReceiptImage(path);

  Future<bool> approvePayment(String bookingId) => _review(
    action: () => _repository.approvePayment(bookingId),
    refresh: loadPendingPayments,
    onConfirmed: () => _removePayment(bookingId),
  );

  Future<bool> rejectPayment(String bookingId) => _review(
    action: () => _repository.rejectPayment(bookingId),
    refresh: loadPendingPayments,
    onConfirmed: () => _removePayment(bookingId),
  );

  void _removePayment(String bookingId) {
    final items = state.payments
        .where((item) {
          final id = item['bookingId']?.toString() ??
              item['id']?.toString();
          return id != bookingId;
        })
        .toList(growable: false);
    emit(state.copyWith(payments: items));
  }

  Future<void> loadPendingIdentity({bool append = false}) async {
    if (state.identityLoading) return;
    final currentPage = state.identityPage;
    final pageNumber = append && currentPage != null
        ? currentPage.pageNumber + 1
        : 1;
    if (append && (currentPage == null || !currentPage.hasNextPage)) return;
    emit(state.copyWith(identityLoading: true, clearIdentityError: true));
    try {
      final page = await _repository.getPendingIdentity(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      final items = append
          ? [...?currentPage?.items, ...page.items]
          : page.items;
      emit(
        state.copyWith(
          identityPage: AdminPendingPage(
            items: List.unmodifiable(items),
            pageNumber: page.pageNumber,
            totalPages: page.totalPages,
            totalCount: page.totalCount,
            hasPreviousPage: page.hasPreviousPage,
            hasNextPage: page.hasNextPage,
          ),
          identityLoading: false,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          identityLoading: false,
          identityError: _errorType(error),
        ),
      );
    }
  }

  Future<void> loadPendingProperties({bool append = false}) async {
    if (state.propertiesLoading) return;
    final currentPage = state.propertiesPage;
    final pageNumber = append && currentPage != null
        ? currentPage.pageNumber + 1
        : 1;
    if (append && (currentPage == null || !currentPage.hasNextPage)) return;
    emit(state.copyWith(propertiesLoading: true, clearPropertiesError: true));
    try {
      final page = await _repository.getPendingProperties(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      final items = append
          ? [...?currentPage?.items, ...page.items]
          : page.items;
      emit(
        state.copyWith(
          propertiesPage: AdminPendingPage(
            items: List.unmodifiable(items),
            pageNumber: page.pageNumber,
            totalPages: page.totalPages,
            totalCount: page.totalCount,
            hasPreviousPage: page.hasPreviousPage,
            hasNextPage: page.hasNextPage,
          ),
          propertiesLoading: false,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          propertiesLoading: false,
          propertiesError: _errorType(error),
        ),
      );
    }
  }

  Future<void> loadIdentityDetails(String userId) async {
    emit(
      state.copyWith(
        detailLoading: true,
        clearDetail: true,
        clearIdentityDetails: true,
        clearDetailError: true,
      ),
    );
    try {
      final details = await _repository.getIdentityDetails(userId);
      emit(state.copyWith(identityDetails: details, detailLoading: false));
    } on Object catch (error) {
      emit(
        state.copyWith(detailLoading: false, detailError: _errorType(error)),
      );
    }
  }

  Future<Uint8List> loadIdentityDocumentImage(String path) =>
      _repository.getIdentityDocumentImage(path);

  Future<void> loadPropertyDetails(String propertyId) => _loadDetails(
    () => _repository.getPropertyDetails(propertyId),
    clearIdentityDetails: true,
  );

  Future<void> _loadDetails(
    Future<Map<String, dynamic>> Function() request, {
    bool clearIdentityDetails = false,
  }) async {
    emit(
      state.copyWith(
        detailLoading: true,
        clearDetail: true,
        clearIdentityDetails: clearIdentityDetails,
        clearDetailError: true,
      ),
    );
    try {
      final detail = await request();
      emit(state.copyWith(detail: detail, detailLoading: false));
    } on Object catch (error) {
      emit(
        state.copyWith(detailLoading: false, detailError: _errorType(error)),
      );
    }
  }

  Future<bool> approveIdentity(String userId) => _review(
    action: () => _repository.approveIdentity(userId),
    refresh: loadPendingIdentity,
    onConfirmed: () => _removeIdentity(userId),
  );

  Future<bool> rejectIdentity(String userId) => _review(
    action: () => _repository.rejectIdentity(userId),
    refresh: loadPendingIdentity,
    onConfirmed: () => _removeIdentity(userId),
  );

  Future<bool> approveProperty(String propertyId) => _review(
    action: () => _repository.approveProperty(propertyId),
    refresh: loadPendingProperties,
    onConfirmed: () => _removeProperty(propertyId),
  );

  Future<bool> rejectProperty(String propertyId) => _review(
    action: () => _repository.rejectProperty(propertyId),
    refresh: loadPendingProperties,
    onConfirmed: () => _removeProperty(propertyId),
  );

  void _removeIdentity(String userId) {
    final page = state.identityPage;
    if (page == null) return;
    final items = page.items
        .where((item) => item['userId']?.toString() != userId)
        .toList(growable: false);
    if (items.length == page.items.length) return;
    emit(
      state.copyWith(
        identityPage: AdminPendingPage(
          items: items,
          pageNumber: page.pageNumber,
          totalPages: page.totalPages,
          totalCount: page.totalCount > 0 ? page.totalCount - 1 : 0,
          hasPreviousPage: page.hasPreviousPage,
          hasNextPage: page.hasNextPage,
        ),
      ),
    );
  }

  void _removeProperty(String propertyId) {
    final page = state.propertiesPage;
    if (page == null) return;
    final items = page.items
        .where((item) => item['id']?.toString() != propertyId)
        .toList(growable: false);
    if (items.length == page.items.length) return;
    emit(
      state.copyWith(
        propertiesPage: AdminPendingPage(
          items: items,
          pageNumber: page.pageNumber,
          totalPages: page.totalPages,
          totalCount: page.totalCount > 0 ? page.totalCount - 1 : 0,
          hasPreviousPage: page.hasPreviousPage,
          hasNextPage: page.hasNextPage,
        ),
      ),
    );
  }

  Future<bool> _review({
    required Future<Object?> Function() action,
    required Future<void> Function() refresh,
    required void Function() onConfirmed,
  }) async {
    if (state.processing) return false;
    emit(state.copyWith(processing: true, clearActionError: true));
    try {
      await action();
      onConfirmed();
      emit(state.copyWith(processing: false));
      await refresh();
      return true;
    } on Object catch (error) {
      emit(state.copyWith(processing: false, actionError: _errorType(error)));
      return false;
    }
  }

  AppErrorType _errorType(Object error) =>
      error is AppException ? error.errorType : AppErrorType.unknown;
}
