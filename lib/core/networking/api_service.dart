import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/core/security/models/refresh_request_model.dart';
import 'package:egypto/core/security/models/refresh_response_model.dart';
import 'package:egypto/features/auth/login/data/model/login_request_model.dart';
import 'package:egypto/features/auth/login/data/model/login_response_model.dart';
import 'package:egypto/features/auth/register/data/models/register_request_model.dart';
import 'package:egypto/features/auth/register/data/models/register_response_model.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:retrofit/retrofit.dart';
part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);

  @POST(ApiConstants.register)
  Future<RegisterResponseModel> register(@Body() RegisterRequestModel request);

  @POST(ApiConstants.refresh)
  Future<RefreshResponseModel> refreshToken(
    @Body() RefreshRequestModel refreshToken,
  );

  @GET(ApiConstants.getProfile)
  Future<UserProfileModel> getProfile();
}
