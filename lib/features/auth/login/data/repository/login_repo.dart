import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/auth/login/data/model/login_request_model.dart';
import 'package:egypto/features/auth/login/data/model/login_response_model.dart';

class LoginRepo {
  final ApiService apiService;

  LoginRepo(this.apiService);
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      return await apiService.login(request);
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }
}
