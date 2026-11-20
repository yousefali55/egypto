import 'dart:io';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/my_account/data/models/identity_verification_request.dart';
import 'package:egypto/features/my_account/data/models/update_profile_phone_request.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';

class MyAccountRepo {
  MyAccountRepo(this._apiService);

  final ApiService _apiService;
  UserProfileModel? _cachedProfile;

  UserProfileModel? get cachedProfile => _cachedProfile;

  Future<UserProfileModel> getProfile() async {
    try {
      final profile = await _apiService.getProfile();
      _cachedProfile = profile;
      return profile;
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<UserProfileModel> activateHost() async {
    try {
      await _apiService.activateHost();
      final profile = await _apiService.getProfile();
      _cachedProfile = profile;
      if (!profile.isHost) {
        throw const AppException(
          errorType: AppErrorType.validation,
          message: 'Host activation was not reflected in the profile.',
        );
      }
      return profile;
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<String?> updatePhone(String phone) async {
    try {
      var profile = _cachedProfile;
      if (!_hasRequiredNames(profile)) {
        try {
          profile = await _apiService.getProfile();
        } on DioException {
          rethrow;
        } on Object {
          throw const AppException(
            errorType: AppErrorType.profileUnavailable,
            message: 'Profile details could not be loaded for phone update.',
          );
        }

        _cachedProfile = profile;
      }

      if (!_hasRequiredNames(profile)) {
        throw const AppException(
          errorType: AppErrorType.profileUnavailable,
          message: 'Profile first and last name are required to update phone.',
        );
      }
      final currentProfile = profile!;

      final response = await _apiService.updateProfilePhone(
        UpdateProfilePhoneRequest(
          firstName: currentProfile.firstName.trim(),
          lastName: currentProfile.lastName.trim(),
          phone: phone,
        ),
      );

      final responsePhone = response is Map ? response['phone'] : null;
      final updatedPhone =
          responsePhone is String && responsePhone.trim().isNotEmpty
          ? responsePhone.trim()
          : phone;
      _cachedProfile = UserProfileModel(
        id: currentProfile.id,
        firstName: currentProfile.firstName,
        lastName: currentProfile.lastName,
        email: currentProfile.email,
        phone: updatedPhone,
        isHost: currentProfile.isHost,
        isAdmin: currentProfile.isAdmin,
        identityVerificationStatus: currentProfile.identityVerificationStatus,
        createdAt: currentProfile.createdAt,
      );
      return updatedPhone;
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<void> submitIdentityVerification(
    IdentityVerificationRequest request, {
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final selfie = await MultipartFile.fromFile(request.selfiePath);
      final front = await MultipartFile.fromFile(request.nationalIdFrontPath);
      final back = await MultipartFile.fromFile(request.nationalIdBackPath);
      await _apiService.submitIdentityVerification(
        selfie,
        front,
        back,
        onSendProgress,
      );
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    } on FileSystemException {
      throw const AppException(
        errorType: AppErrorType.invalidUpload,
        message: 'One of the selected images is no longer available.',
      );
    }
  }

  bool _hasRequiredNames(UserProfileModel? profile) =>
      profile != null &&
      profile.firstName.trim().isNotEmpty &&
      profile.lastName.trim().isNotEmpty;
}
