import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/bookings/data/models/booking_models.dart';
import 'package:egypto/features/bookings/data/models/property_details.dart';
import 'package:http_parser/http_parser.dart';

class BookingRepository {
  BookingRepository(this._apiService);

  final ApiService _apiService;

  Future<PropertyDetails> getProperty(String propertyId) async {
    try {
      final response = await _apiService.getProperty(propertyId);
      if (response is! Map) {
        throw const FormatException('Property response must be an object.');
      }
      final property = PropertyDetails.fromJson(
        Map<String, dynamic>.from(response),
      );
      if (property.id != propertyId || property.title.isEmpty) {
        throw const FormatException('Property response is incomplete.');
      }
      return property;
    } on DioException catch (error) {
      throw _bookingFailure(error);
    }
  }

  Future<BookingDetails> createBooking({
    required String propertyId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    try {
      final booking = await _apiService.createBooking(
        CreateBookingRequest(
          propertyId: propertyId,
          checkInDate: dateOnly(checkInDate),
          checkOutDate: dateOnly(checkOutDate),
        ),
      );
      if (booking.id.isEmpty || booking.status == null) {
        throw const FormatException('Booking response is incomplete.');
      }
      return booking;
    } on DioException catch (error) {
      throw _bookingFailure(error);
    }
  }

  Future<BookingPage> getGuestBookings({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      return await _apiService.getGuestBookings(pageNumber, pageSize);
    } on DioException catch (error) {
      throw _bookingFailure(error);
    }
  }

  Future<BookingDetails> getBookingDetails(String bookingId) async {
    try {
      final booking = await _apiService.getBookingDetails(bookingId);
      if (booking.id != bookingId) {
        throw const FormatException('Booking detail response ID mismatch.');
      }
      return booking;
    } on DioException catch (error) {
      throw _bookingFailure(error);
    }
  }

  Future<HostBookingPage> getHostBookings({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      return await _apiService.getHostBookings(pageNumber, pageSize);
    } on DioException catch (error) {
      throw _bookingFailure(error);
    }
  }

  Future<BookingDetails> submitPaymentReceipt({
    required String bookingId,
    required String filePath,
    required String fileName,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final lowerName = fileName.toLowerCase();
      if (!lowerName.endsWith('.jpg') &&
          !lowerName.endsWith('.jpeg') &&
          !lowerName.endsWith('.png')) {
        throw const AppException(
          errorType: AppErrorType.invalidUpload,
          message: 'Only JPG and PNG receipt images are supported.',
        );
      }
      final multipart = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: MediaType(
          'image',
          lowerName.endsWith('.png') ? 'png' : 'jpeg',
        ),
      );
      final response = await _apiService.submitPaymentReceipt(
        bookingId,
        multipart,
        onSendProgress,
      );
      if (response is Map) {
        final booking = BookingDetails.fromJson(
          Map<String, dynamic>.from(response),
        );
        if (booking.id.isNotEmpty) return booking;
      }
      return await getBookingDetails(bookingId);
    } on AppException {
      rethrow;
    } on DioException catch (error) {
      throw _bookingFailure(error);
    }
  }

  Future<BookingDecisionResponse> acceptBooking(String bookingId) async {
    try {
      final result = await _apiService.acceptHostBooking(bookingId);
      if (result.id != bookingId) {
        throw const FormatException('Booking decision response ID mismatch.');
      }
      return result;
    } on DioException catch (error) {
      throw _bookingFailure(error);
    }
  }

  Future<BookingDecisionResponse> rejectBooking(String bookingId) async {
    try {
      final result = await _apiService.rejectHostBooking(bookingId);
      if (result.id != bookingId) {
        throw const FormatException('Booking decision response ID mismatch.');
      }
      return result;
    } on DioException catch (error) {
      throw _bookingFailure(error);
    }
  }

  BookingApiException _bookingFailure(DioException exception) {
    final response = exception.response;
    final data = response?.data;
    final code = data is Map
        ? (data['code'] ?? data['errorCode'] ?? data['title'])?.toString()
        : null;
    return BookingApiException(
      code: code,
      statusCode: response?.statusCode,
      cause: ApiErrorHandler.handle(exception),
    );
  }
}
