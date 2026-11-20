import 'package:bloc/bloc.dart';
import 'package:egypto/features/bookings/data/models/booking_models.dart';
import 'package:egypto/features/bookings/data/repository/booking_repository.dart';

sealed class HostBookingsState {}

final class HostBookingsLoading extends HostBookingsState {}

final class HostBookingsFailure extends HostBookingsState {
  HostBookingsFailure(this.error);

  final Object error;
}

final class HostBookingsLoaded extends HostBookingsState {
  HostBookingsLoaded({
    required this.page,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.operationError,
    this.actingBookingId,
    this.lastDecision,
  });

  final HostBookingPage page;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final Object? operationError;
  final String? actingBookingId;
  final BookingDecisionResponse? lastDecision;
}

class HostBookingsCubit extends Cubit<HostBookingsState> {
  HostBookingsCubit(this._repository) : super(HostBookingsLoading());

  static const pageSize = 20;
  final BookingRepository _repository;
  bool _loading = false;

  Future<void> loadFirstPage() async {
    if (_loading) return;
    _loading = true;
    final previousDecision = state is HostBookingsLoaded
        ? (state as HostBookingsLoaded).lastDecision
        : null;
    emit(HostBookingsLoading());
    try {
      final page = await _repository.getHostBookings(
        pageNumber: 1,
        pageSize: pageSize,
      );
      if (!isClosed) {
        emit(HostBookingsLoaded(page: page, lastDecision: previousDecision));
      }
    } catch (error) {
      if (!isClosed) emit(HostBookingsFailure(error));
    } finally {
      _loading = false;
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (_loading ||
        currentState is! HostBookingsLoaded ||
        !currentState.page.hasNextPage) {
      return;
    }
    _loading = true;
    emit(HostBookingsLoaded(page: currentState.page, isLoadingMore: true));
    try {
      final nextPage = await _repository.getHostBookings(
        pageNumber: currentState.page.pageNumber + 1,
        pageSize: pageSize,
      );
      if (!isClosed) {
        emit(
          HostBookingsLoaded(
            page: HostBookingPage(
              items: [...currentState.page.items, ...nextPage.items],
              totalCount: nextPage.totalCount,
              pageNumber: nextPage.pageNumber,
              pageSize: nextPage.pageSize,
              totalPages: nextPage.totalPages,
              hasNextPage: nextPage.hasNextPage,
              hasPreviousPage: nextPage.hasPreviousPage,
            ),
          ),
        );
      }
    } catch (error) {
      if (!isClosed) {
        emit(HostBookingsLoaded(page: currentState.page, loadMoreError: error));
      }
    } finally {
      _loading = false;
    }
  }

  Future<void> accept(String bookingId) => _decide(bookingId, accept: true);

  Future<void> reject(String bookingId) => _decide(bookingId, accept: false);

  Future<void> _decide(String bookingId, {required bool accept}) async {
    final currentState = state;
    if (_loading || currentState is! HostBookingsLoaded) return;
    _loading = true;
    emit(
      HostBookingsLoaded(
        page: currentState.page,
        actingBookingId: bookingId,
        lastDecision: currentState.lastDecision,
      ),
    );
    late final BookingDecisionResponse result;
    try {
      result = accept
          ? await _repository.acceptBooking(bookingId)
          : await _repository.rejectBooking(bookingId);
    } catch (error) {
      if (!isClosed) {
        emit(
          HostBookingsLoaded(
            page: currentState.page,
            lastDecision: currentState.lastDecision,
            operationError: error,
          ),
        );
      }
      _loading = false;
      return;
    }

    final visiblePage = _withoutBooking(currentState.page, bookingId);
    if (!isClosed) {
      emit(HostBookingsLoaded(page: visiblePage, lastDecision: result));
    }
    try {
      final refreshed = await _repository.getHostBookings(
        pageNumber: 1,
        pageSize: pageSize,
      );
      if (!isClosed) {
        emit(HostBookingsLoaded(page: refreshed, lastDecision: result));
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          HostBookingsLoaded(
            page: visiblePage,
            lastDecision: result,
            loadMoreError: error,
          ),
        );
      }
    } finally {
      _loading = false;
    }
  }

  HostBookingPage _withoutBooking(HostBookingPage page, String bookingId) =>
      HostBookingPage(
        items: page.items.where((item) => item.id != bookingId).toList(),
        totalCount: page.totalCount > 0 ? page.totalCount - 1 : 0,
        pageNumber: page.pageNumber,
        pageSize: page.pageSize,
        totalPages: page.totalPages,
        hasNextPage: page.hasNextPage,
        hasPreviousPage: page.hasPreviousPage,
      );
}
