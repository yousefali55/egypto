import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/admin/data/models/admin_identity_details.dart';
import 'package:egypto/features/admin/data/models/admin_pending_page.dart';

class AdminRepo {
  AdminRepo(this._apiService, this._dio);

  final ApiService _apiService;
  final Dio _dio;

  Future<List<Map<String, dynamic>>> getPendingPayments() async {
    try {
      final response = await _apiService.getAdminPendingPayments();
      if (response is Map) {
        final map = Map<String, dynamic>.from(response);
        final raw = map['items'] ?? map['payments'] ?? map['data'];
        if (raw is List) {
          return raw
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(growable: false);
        }
      }
      if (response is List) {
        return response
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false);
      }
      throw const AppException(
        errorType: AppErrorType.validation,
        message: 'The pending payments response did not contain a list.',
      );
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<Map<String, dynamic>> getPaymentReceipt(String bookingId) async {
    try {
      final response = await _apiService.getAdminPaymentReceipt(bookingId);
      if (response is Map) return Map<String, dynamic>.from(response);
      if (response is String) return {'receiptUrl': response};
      throw const AppException(
        errorType: AppErrorType.validation,
        message: 'The payment receipt response did not contain receipt details.',
      );
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<Uint8List> getPaymentReceiptImage(String path) =>
      getIdentityDocumentImage(path);

  Future<Object?> approvePayment(String bookingId) =>
      _runAction(() => _apiService.approveAdminPayment(bookingId));

  Future<Object?> rejectPayment(String bookingId, {String? reason}) async {
    return _runAction(() => _apiService.rejectAdminPayment(bookingId));
  }

  Future<AdminPendingPage> getPendingIdentity({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      return AdminPendingPage.fromJson(
        await _apiService.getAdminPendingIdentity(pageNumber, pageSize),
      );
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<AdminPendingPage> getPendingProperties({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      return AdminPendingPage.fromJson(
        await _apiService.getAdminPendingProperties(pageNumber, pageSize),
      );
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<AdminIdentityDetails> getIdentityDetails(String userId) async =>
      AdminIdentityDetails.fromJson(
        await _getDetails(() => _apiService.getAdminIdentityDetails(userId)),
      );

  Future<Uint8List> getIdentityDocumentImage(String path) async {
    final url = ApiConstants.resolveUploadUrl(path);
    if (url == null) {
      throw const AppException(
        errorType: AppErrorType.validation,
        message: 'The identity document URL is invalid.',
      );
    }

    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        throw const AppException(
          errorType: AppErrorType.server,
          message: 'The identity document response was empty.',
        );
      }
      final contentType = response.headers
          .value(Headers.contentTypeHeader)
          ?.toLowerCase();
      if (contentType != null &&
          (contentType.startsWith('text/') ||
              contentType.contains('json') ||
              contentType.contains('html'))) {
        throw const AppException(
          errorType: AppErrorType.server,
          message: 'The identity document endpoint did not return an image.',
        );
      }
      return Uint8List.fromList(bytes);
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<Map<String, dynamic>> getPropertyDetails(String propertyId) =>
      _getDetails(() => _apiService.getAdminPropertyDetails(propertyId));

  Future<Object?> approveIdentity(String userId) =>
      _runAction(() => _apiService.approveAdminIdentity(userId));

  Future<Object?> rejectIdentity(String userId) =>
      _runAction(() => _apiService.rejectAdminIdentity(userId));

  Future<Object?> approveProperty(String propertyId) =>
      _runAction(() => _apiService.approveAdminProperty(propertyId));

  Future<Object?> rejectProperty(String propertyId) =>
      _runAction(() => _apiService.rejectAdminProperty(propertyId));

  Future<Map<String, dynamic>> _getDetails(
    Future<dynamic> Function() request,
  ) async {
    try {
      final response = await request();
      if (response is Map) return Map<String, dynamic>.from(response);
      throw const AppException(
        errorType: AppErrorType.validation,
        message: 'The detail response did not contain an object.',
      );
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<Object?> _runAction(Future<dynamic> Function() request) async {
    try {
      return await request();
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }
}
