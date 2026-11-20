import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/bookings/data/models/booking_models.dart';
import 'package:egypto/features/bookings/data/models/property_details.dart';
import 'package:egypto/features/bookings/data/repository/booking_repository.dart';
import 'package:egypto/features/bookings/presentation/cubit/guest_booking_cubit.dart';
import 'package:egypto/features/bookings/presentation/cubit/host_bookings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'guest history fetches pages on demand and appends the next page',
    () async {
      final repository = _BookingRepository();
      repository.guestPages = [
        _guestPage(
          items: [_booking('booking-1')],
          pageNumber: 1,
          hasNextPage: true,
        ),
        _guestPage(
          items: [_booking('booking-2')],
          pageNumber: 2,
          hasNextPage: false,
        ),
      ];
      final cubit = GuestBookingsCubit(repository);

      await cubit.loadFirstPage();
      expect(repository.guestPageCalls, [1]);
      expect((cubit.state as GuestBookingsLoaded).page.items, hasLength(1));

      await cubit.loadNextPage();
      final loaded = cubit.state as GuestBookingsLoaded;
      expect(repository.guestPageCalls, [1, 2]);
      expect(loaded.page.items.map((item) => item.id), [
        'booking-1',
        'booking-2',
      ]);
      expect(loaded.page.hasNextPage, isFalse);

      await cubit.close();
    },
  );

  test(
    'host decision uses actual result and refreshes the pending list',
    () async {
      final repository = _BookingRepository();
      repository.hostPages = [
        _hostPage([_hostRequest('booking-1'), _hostRequest('booking-2')]),
        _hostPage([_hostRequest('booking-2')]),
      ];
      final cubit = HostBookingsCubit(repository);

      await cubit.loadFirstPage();
      await cubit.accept('booking-1');

      final loaded = cubit.state as HostBookingsLoaded;
      expect(repository.acceptedIds, ['booking-1']);
      expect(repository.hostPageCalls, [1, 1]);
      expect(loaded.page.items.map((item) => item.id), ['booking-2']);
      expect(loaded.lastDecision?.status, 'Confirmed');
      expect(loaded.lastDecision?.paymentStatus, 'Held');

      await cubit.close();
    },
  );

  test(
    'booking creation failure keeps loaded property and date context',
    () async {
      final repository = _BookingRepository()
        ..property = const PropertyDetails(
          id: 'property-1',
          title: 'Waterfront apartment',
        )
        ..createError = const BookingApiException(
          code: 'DatesUnavailable',
          statusCode: 409,
        );
      final cubit = GuestBookingCubit(repository);
      final checkIn = DateTime(2026, 11, 10);
      final checkOut = DateTime(2026, 11, 15);

      await cubit.loadProperty('property-1');
      await cubit.createBooking(
        propertyId: 'property-1',
        checkInDate: checkIn,
        checkOutDate: checkOut,
      );

      final failure = cubit.state as BookingFlowFailure;
      expect(failure.property?.id, 'property-1');
      expect(failure.error, isA<BookingApiException>());
      expect(repository.bookingDates, [checkIn, checkOut]);

      await cubit.close();
    },
  );
}

class _BookingRepository extends BookingRepository {
  _BookingRepository() : super(ApiService(Dio()));

  final List<int> guestPageCalls = [];
  final List<int> hostPageCalls = [];
  final List<String> acceptedIds = [];
  List<BookingPage> guestPages = [];
  List<HostBookingPage> hostPages = [];
  PropertyDetails? property;
  Object? createError;
  List<DateTime>? bookingDates;

  @override
  Future<BookingPage> getGuestBookings({
    required int pageNumber,
    required int pageSize,
  }) async {
    guestPageCalls.add(pageNumber);
    return guestPages[pageNumber - 1];
  }

  @override
  Future<HostBookingPage> getHostBookings({
    required int pageNumber,
    required int pageSize,
  }) async {
    hostPageCalls.add(pageNumber);
    return hostPages[hostPageCalls.length - 1];
  }

  @override
  Future<BookingDecisionResponse> acceptBooking(String bookingId) async {
    acceptedIds.add(bookingId);
    return BookingDecisionResponse(
      id: bookingId,
      status: 'Confirmed',
      paymentStatus: 'Held',
    );
  }

  @override
  Future<PropertyDetails> getProperty(String propertyId) async => property!;

  @override
  Future<BookingDetails> createBooking({
    required String propertyId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    bookingDates = [checkInDate, checkOutDate];
    final failure = createError;
    if (failure != null) throw failure;
    return _booking('booking-1');
  }
}

BookingPage _guestPage({
  required List<BookingDetails> items,
  required int pageNumber,
  required bool hasNextPage,
}) => BookingPage(
  items: items,
  totalCount: items.length,
  pageNumber: pageNumber,
  pageSize: 20,
  totalPages: hasNextPage ? 2 : pageNumber,
  hasNextPage: hasNextPage,
  hasPreviousPage: pageNumber > 1,
);

HostBookingPage _hostPage(List<HostBookingRequest> items) => HostBookingPage(
  items: items,
  totalCount: items.length,
  pageNumber: 1,
  pageSize: 20,
  totalPages: 1,
  hasNextPage: false,
  hasPreviousPage: false,
);

BookingDetails _booking(String id) => BookingDetails(
  id: id,
  propertyId: 'property-1',
  propertyTitle: 'Apartment',
);

HostBookingRequest _hostRequest(String id) =>
    HostBookingRequest(id: id, guestName: 'Guest', propertyTitle: 'Apartment');
