import 'dart:io';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/host_properties/data/models/create_property_request.dart';
import 'package:egypto/features/host_properties/data/models/host_properties_page.dart';

class HostPropertiesRepo {
  HostPropertiesRepo(this._apiService);

  final ApiService _apiService;

  Future<List<Amenity>> getAmenities() async {
    try {
      final response = await _apiService.getAmenities();
      if (response is! List) {
        throw const AppException(
          errorType: AppErrorType.validation,
          message: 'The amenities response was not a list.',
        );
      }
      return response
          .whereType<Map>()
          .map((item) => Amenity.fromJson(Map<String, dynamic>.from(item)))
          .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
          .toList(growable: false);
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<HostPropertiesPage> getHostProperties({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      return await _apiService.getHostProperties(pageNumber, pageSize);
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<String> createProperty(CreatePropertyRequest request) async {
    try {
      final response = await _apiService.createProperty(request.toJson());
      final propertyId = _findPropertyId(response);
      if (propertyId == null) {
        throw StateError(
          'Property creation response did not contain a valid property ID.',
        );
      }
      return propertyId;
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<void> uploadPropertyImages(
    String propertyId,
    List<String> paths, {
    Set<String> alreadyUploadedPaths = const {},
    void Function(String)? onImageUploaded,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final pendingPaths = paths
          .where((path) => !alreadyUploadedPaths.contains(path))
          .toList(growable: false);
      final fileSizes = await Future.wait(
        pendingPaths.map((path) => File(path).length()),
      );
      final totalBytes = fileSizes.fold<int>(0, (total, size) => total + size);
      var completedBytes = 0;

      for (var index = 0; index < pendingPaths.length; index++) {
        final path = pendingPaths[index];
        final fileSize = fileSizes[index];
        final file = await MultipartFile.fromFile(path);
        await _apiService.uploadPropertyImages(
          propertyId,
          [file],
          onSendProgress == null
              ? null
              : (sent, total) {
                  final progress = total > 0 ? sent / total : 0.0;
                  onSendProgress(
                    completedBytes + (fileSize * progress).round(),
                    totalBytes,
                  );
                },
        );
        completedBytes += fileSize;
        onImageUploaded?.call(path);
        onSendProgress?.call(completedBytes, totalBytes);
      }
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    } on FileSystemException {
      throw const AppException(
        errorType: AppErrorType.invalidUpload,
        message: 'A selected image is no longer available. Select it again.',
      );
    }
  }

  Future<String?> submitProperty(String propertyId) async {
    try {
      final response = await _apiService.submitProperty(propertyId);
      return _findPropertyStatus(response);
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<String?> getPropertyStatus(String propertyId) async {
    try {
      var pageNumber = 1;
      var totalPages = 1;
      while (pageNumber <= totalPages) {
        final page = await _apiService.getHostProperties(pageNumber, 20);
        totalPages = page.totalPages;
        for (final property in page.items) {
          if (property.id == propertyId && property.status.trim().isNotEmpty) {
            return property.status;
          }
        }
        pageNumber++;
      }
      return null;
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  String? _findPropertyId(Object? response) {
    if (response is String && _isUuid(response)) return response;
    if (response is! Map) return null;
    for (final key in ['id', 'propertyId']) {
      final value = response[key];
      if (value is String && _isUuid(value)) return value;
    }
    for (final key in ['data', 'property', 'result']) {
      final nested = _findPropertyId(response[key]);
      if (nested != null) return nested;
    }
    return null;
  }

  String? _findPropertyStatus(Object? response) {
    if (response is String && response.trim().isNotEmpty) return response;
    if (response is! Map) return null;
    final status = response['status'];
    if (status is String && status.trim().isNotEmpty) return status;
    for (final key in ['data', 'property', 'result']) {
      final nested = _findPropertyStatus(response[key]);
      if (nested != null) return nested;
    }
    return null;
  }

  bool _isUuid(String value) => RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-8][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  ).hasMatch(value);
}
