import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/bookings/data/repository/booking_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const bookingId = 'booking-uuid-123';
  const propertyId = 'b2222222-2222-2222-2222-222222222222';
  final requests = <RequestOptions>[];
  late ApiService service;

  setUp(() {
    requests.clear();
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid/api/v1/'))
      ..httpClientAdapter = _CallbackAdapter((options) async {
        requests.add(options);
        final response = switch (options.path) {
          'bookings' when options.method == 'POST' => {
            'id': bookingId,
            'propertyId': propertyId,
            'propertyTitle': 'Downtown Apartment',
            'checkInDate': '2026-11-10',
            'checkOutDate': '2026-11-15',
            'status': 'Pending',
            'financialSnapshot': {
              'nightlyPrice': 150.0,
              'numberOfNights': 5,
              'grossAmount': 750.0,
              'serviceFee': 75.0,
              'hostAmount': 675.0,
            },
            'paymentStatus': 'Held',
            'createdAt': '2026-10-25T10:00:00Z',
            'expiresAt': '2026-10-26T10:00:00Z',
          },
          'bookings' => _page(
            items: [
              {
                'id': bookingId,
                'propertyTitle': 'Downtown Apartment',
                'checkInDate': '2026-11-10',
                'checkOutDate': '2026-11-15',
                'status': 'Pending',
                'grossAmount': 750.0,
                'createdAt': '2026-10-25T10:00:00Z',
              },
            ],
          ),
          'bookings/$bookingId' => {
            'id': bookingId,
            'property': {
              'id': propertyId,
              'title': 'Downtown Apartment',
              'address': '15 Street 1, Zamalek, Cairo',
            },
            'checkInDate': '2026-11-10',
            'checkOutDate': '2026-11-15',
            'status': 'Pending',
            'financialSnapshot': {
              'nightlyPrice': 150.0,
              'numberOfNights': 5,
              'grossAmount': 750.0,
              'serviceFee': 75.0,
              'hostAmount': 675.0,
            },
            'paymentStatus': 'Held',
            'createdAt': '2026-10-25T10:00:00Z',
            'decidedAt': null,
          },
          'host/bookings' => _page(
            items: [
              {
                'id': bookingId,
                'guestName': 'John Doe',
                'propertyTitle': 'Downtown Apartment',
                'checkInDate': '2026-11-10',
                'checkOutDate': '2026-11-15',
                'grossAmount': 750.0,
                'createdAt': '2026-10-25T10:00:00Z',
                'hoursRemaining': 18.5,
              },
            ],
          ),
          'host/bookings/$bookingId/accept' => {
            'id': bookingId,
            'status': 'Confirmed',
            'paymentStatus': 'Held',
            'decidedAt': '2026-10-25T12:00:00Z',
            'message': 'Booking accepted successfully.',
          },
          'host/bookings/$bookingId/reject' => {
            'id': bookingId,
            'status': 'Rejected',
            'paymentStatus': 'Refunded',
            'decidedAt': '2026-10-25T12:00:00Z',
            'message': 'Booking rejected.',
          },
          _ => <String, dynamic>{},
        };
        return ResponseBody.fromString(
          jsonEncode(response),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
    service = ApiService(dio);
  });

  test('create booking sends only property ID and date-only values', () async {
    final booking = await BookingRepository(service).createBooking(
      propertyId: propertyId,
      checkInDate: DateTime(2026, 11, 4, 23, 45),
      checkOutDate: DateTime(2026, 11, 10, 0, 15),
    );

    expect(requests.single.method, 'POST');
    expect(requests.single.path, ApiConstants.bookings);
    expect(requests.single.contentType, Headers.jsonContentType);
    expect(requests.single.data, {
      'propertyId': propertyId,
      'checkInDate': '2026-11-04',
      'checkOutDate': '2026-11-10',
    });
    expect(
      jsonEncode(requests.single.data),
      '{"propertyId":"$propertyId","checkInDate":"2026-11-04","checkOutDate":"2026-11-10"}',
    );
    expect(
      (requests.single.data as Map).keys,
      unorderedEquals(['propertyId', 'checkInDate', 'checkOutDate']),
    );
    expect(booking.financialSnapshot.grossAmount, 750);
    expect(booking.financialSnapshot.serviceFee, 75);
    expect(booking.paymentStatus, 'Held');
  });

  test('guest history and detail requests use documented contracts', () async {
    final page = await service.getGuestBookings(2, 20);
    final detail = await service.getBookingDetails(bookingId);

    expect(requests[0].method, 'GET');
    expect(requests[0].path, ApiConstants.bookings);
    expect(requests[0].queryParameters, {'pageNumber': 2, 'pageSize': 20});
    expect(page.items.single.financialSnapshot.grossAmount, 750);
    expect(page.items.single.propertyTitle, 'Downtown Apartment');
    expect(requests[1].method, 'GET');
    expect(requests[1].path, 'bookings/$bookingId');
    expect(detail.propertyTitle, 'Downtown Apartment');
    expect(detail.propertyAddress, '15 Street 1, Zamalek, Cairo');
    expect(detail.financialSnapshot.hostAmount, 675);
  });

  test(
    'host requests paginate without inventing pending query parameters',
    () async {
      final page = await service.getHostBookings(1, 20);

      expect(requests.single.method, 'GET');
      expect(requests.single.path, ApiConstants.hostBookings);
      expect(requests.single.queryParameters, {
        'pageNumber': 1,
        'pageSize': 20,
      });
      expect(page.items.single.hoursRemaining, 18.5);
    },
  );

  test('accept and reject use booking IDs and bodyless POSTs', () async {
    final accepted = await service.acceptHostBooking(bookingId);
    final rejected = await service.rejectHostBooking(bookingId);

    expect(requests.map((request) => request.method), ['POST', 'POST']);
    expect(requests[0].path, 'host/bookings/$bookingId/accept');
    expect(requests[1].path, 'host/bookings/$bookingId/reject');
    expect(requests.map((request) => request.data), everyElement(isNull));
    expect(accepted.status, 'Confirmed');
    expect(accepted.paymentStatus, 'Held');
    expect(rejected.status, 'Rejected');
    expect(rejected.paymentStatus, 'Refunded');
  });
}

Map<String, dynamic> _page({required List<Map<String, dynamic>> items}) => {
  'items': items,
  'totalCount': items.length,
  'pageNumber': 1,
  'pageSize': 20,
  'totalPages': 1,
  'hasNextPage': false,
  'hasPreviousPage': false,
};

class _CallbackAdapter implements HttpClientAdapter {
  _CallbackAdapter(this.callback);

  final Future<ResponseBody> Function(RequestOptions) callback;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await requestStream?.drain<void>();
    return callback(options);
  }

  @override
  void close({bool force = false}) {}
}
