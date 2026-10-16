import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/auth/register/data/models/register_request_model.dart';
import 'package:egypto/features/auth/register/data/models/register_response_model.dart';

class RegisterRepo {
  final ApiService apiService;

  new(this.apiService);
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      return await apiService.register(request);
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }
}
