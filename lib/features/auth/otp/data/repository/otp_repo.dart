import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/auth/otp/data/models/otp_requests.dart';

class OtpRepo {
  const OtpRepo(this.apiService);

  final ApiService apiService;

  Future<void> verifyOtp(VerifyOtpRequest request) async {
    try {
      await apiService.verifyOtp(request);
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }

  Future<void> resendOtp(ResendOtpRequest request) async {
    try {
      await apiService.resendOtp(request);
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }
}
