import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/core/security/models/refresh_request_model.dart';
import 'package:egypto/core/security/models/refresh_response_model.dart';
import 'package:egypto/features/auth/login/data/model/login_request_model.dart';
import 'package:egypto/features/auth/login/data/model/login_response_model.dart';
import 'package:egypto/features/auth/otp/data/models/otp_requests.dart';
import 'package:egypto/features/auth/register/data/models/register_request_model.dart';
import 'package:egypto/features/auth/register/data/models/register_response_model.dart';
import 'package:egypto/features/my_account/data/models/update_profile_phone_request.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/host_properties/data/models/host_properties_page.dart';
import 'package:egypto/features/home/data/models/search_properties_page.dart';
import 'package:egypto/features/bookings/data/models/booking_models.dart';
import 'package:retrofit/retrofit.dart';
part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);

  @POST(ApiConstants.register)
  Future<RegisterResponseModel> register(@Body() RegisterRequestModel request);

  @POST(ApiConstants.verifyOtp)
  Future<dynamic> verifyOtp(@Body() VerifyOtpRequest request);

  @POST(ApiConstants.resendOtp)
  Future<dynamic> resendOtp(@Body() ResendOtpRequest request);

  @POST(ApiConstants.refresh)
  Future<RefreshResponseModel> refreshToken(
    @Body() RefreshRequestModel refreshToken,
  );

  @GET('${ApiConstants.adminIdentity}/pending')
  Future<dynamic> getAdminPendingIdentity(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize,
  );

  @GET('${ApiConstants.adminIdentity}/{userId}')
  Future<dynamic> getAdminIdentityDetails(@Path('userId') String userId);

  @POST('${ApiConstants.adminIdentity}/{userId}/approve')
  Future<dynamic> approveAdminIdentity(@Path('userId') String userId);

  @POST('${ApiConstants.adminIdentity}/{userId}/reject')
  Future<dynamic> rejectAdminIdentity(@Path('userId') String userId);

  @GET(ApiConstants.adminPendingProperties)
  Future<dynamic> getAdminPendingProperties(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize,
  );

  @GET('${ApiConstants.adminProperties}/{id}')
  Future<dynamic> getAdminPropertyDetails(@Path('id') String propertyId);

  @POST('${ApiConstants.adminProperties}/{id}/approve')
  Future<dynamic> approveAdminProperty(@Path('id') String propertyId);

  @POST('${ApiConstants.adminProperties}/{id}/reject')
  Future<dynamic> rejectAdminProperty(@Path('id') String propertyId);

  @GET(ApiConstants.getProfile)
  Future<UserProfileModel> getProfile();

  @PUT(ApiConstants.getProfile)
  Future<dynamic> updateProfilePhone(@Body() UpdateProfilePhoneRequest request);

  @POST(ApiConstants.activateHost)
  Future<void> activateHost();

  @GET(ApiConstants.hostProperties)
  Future<HostPropertiesPage> getHostProperties(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize,
  );

  @GET(ApiConstants.searchProperties)
  Future<SearchPropertiesPage> searchProperties(
    @Queries() Map<String, dynamic> filters,
  );

  @GET(ApiConstants.amenities)
  Future<dynamic> getAmenities();

  @POST(ApiConstants.properties)
  Future<dynamic> createProperty(@Body() Map<String, dynamic> request);

  @MultiPart()
  @POST('${ApiConstants.properties}/{propertyId}/images')
  Future<dynamic> uploadPropertyImages(
    @Path('propertyId') String propertyId,
    @Part(name: 'Files') List<MultipartFile> files,
    @SendProgress() ProgressCallback? onSendProgress,
  );

  @POST('${ApiConstants.properties}/{id}/submit')
  Future<dynamic> submitProperty(@Path('id') String propertyId);

  @GET('${ApiConstants.properties}/{id}')
  Future<dynamic> getProperty(@Path('id') String propertyId);

  @POST(ApiConstants.bookings)
  Future<BookingDetails> createBooking(@Body() CreateBookingRequest request);

  @GET(ApiConstants.bookings)
  Future<BookingPage> getGuestBookings(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize,
  );

  @GET('${ApiConstants.bookings}/{id}')
  Future<BookingDetails> getBookingDetails(@Path('id') String bookingId);

  @GET(ApiConstants.hostBookings)
  Future<HostBookingPage> getHostBookings(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize,
  );

  @POST('${ApiConstants.hostBookings}/{id}/accept')
  Future<BookingDecisionResponse> acceptHostBooking(
    @Path('id') String bookingId,
  );

  @POST('${ApiConstants.hostBookings}/{id}/reject')
  Future<BookingDecisionResponse> rejectHostBooking(
    @Path('id') String bookingId,
  );

  @MultiPart()
  @POST('${ApiConstants.bookings}/{id}/payment-receipt')
  Future<dynamic> submitPaymentReceipt(
    @Path('id') String bookingId,
    @Part(name: 'file') MultipartFile file,
    @SendProgress() ProgressCallback? onSendProgress,
  );

  @GET(ApiConstants.adminPayments)
  Future<dynamic> getAdminPendingPayments();

  @GET('${ApiConstants.adminPayments}/{bookingId}/receipt')
  Future<dynamic> getAdminPaymentReceipt(
    @Path('bookingId') String bookingId,
  );

  @POST('${ApiConstants.adminPayments}/{bookingId}/approve')
  Future<dynamic> approveAdminPayment(
    @Path('bookingId') String bookingId,
  );

  @POST('${ApiConstants.adminPayments}/{bookingId}/reject')
  Future<dynamic> rejectAdminPayment(
    @Path('bookingId') String bookingId,
  );

  @MultiPart()
  @POST(ApiConstants.identity)
  Future<void> submitIdentityVerification(
    @Part(name: 'Selfie') MultipartFile selfie,
    @Part(name: 'NationalIdFront') MultipartFile nationalIdFront,
    @Part(name: 'NationalIdBack') MultipartFile nationalIdBack,
    @SendProgress() ProgressCallback? onSendProgress,
  );
}
