import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';

class MyAccountRepo {
  MyAccountRepo(this._apiService);

  final ApiService _apiService;

  Future<UserProfileModel> getProfile() async {
    try {
      return await _apiService.getProfile();
    } on DioException catch (exception) {
      throw ApiErrorHandler.handle(exception);
    }
  }
}
