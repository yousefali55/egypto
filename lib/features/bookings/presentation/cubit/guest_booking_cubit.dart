import 'package:bloc/bloc.dart';
import 'package:egypto/features/bookings/data/models/booking_models.dart';
import 'package:egypto/features/bookings/data/models/property_details.dart';
import 'package:egypto/features/bookings/data/repository/booking_repository.dart';

sealed class BookingFlowState {}

final class BookingFlowLoading extends BookingFlowState {}

final class BookingFlowFailure extends BookingFlowState {
  BookingFlowFailure(this.error, {this.property});

  final Object error;
  final PropertyDetails? property;
}

final class BookingPropertyLoaded extends BookingFlowState {
  BookingPropertyLoaded(this.property);

  final PropertyDetails property;
}

final class BookingCreating extends BookingFlowState {
  BookingCreating(this.property);

  final PropertyDetails property;
}

final class BookingCreated extends BookingFlowState {
  BookingCreated(this.booking);

  final BookingDetails booking;
}

class GuestBookingCubit extends Cubit<BookingFlowState> {
  GuestBookingCubit(this._repository) : super(BookingFlowLoading());

  final BookingRepository _repository;
  PropertyDetails? _property;
  bool _creating = false;

  Future<void> loadProperty(String propertyId) async {
    emit(BookingFlowLoading());
    try {
      _property = await _repository.getProperty(propertyId);
      if (!isClosed) emit(BookingPropertyLoaded(_property!));
    } catch (error) {
      if (!isClosed) emit(BookingFlowFailure(error, property: _property));
    }
  }

  Future<void> retryProperty() async {
    final propertyId = _property?.id;
    if (propertyId != null && propertyId.isNotEmpty) {
      await loadProperty(propertyId);
    }
  }

  Future<void> createBooking({
    required String propertyId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    if (_creating) return;
    final property = _property;
    if (property == null || property.id != propertyId) return;
    _creating = true;
    emit(BookingCreating(property));
    try {
      final booking = await _repository.createBooking(
        propertyId: propertyId,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
      );
      if (!isClosed) emit(BookingCreated(booking));
    } catch (error) {
      if (!isClosed) emit(BookingFlowFailure(error, property: property));
    } finally {
      _creating = false;
    }
  }

  void showProperty() {
    final property = _property;
    if (property != null && !isClosed) emit(BookingPropertyLoaded(property));
  }
}

sealed class GuestBookingsState {}

final class GuestBookingsLoading extends GuestBookingsState {}

final class GuestBookingsFailure extends GuestBookingsState {
  GuestBookingsFailure(this.error);

  final Object error;
}

final class GuestBookingsLoaded extends GuestBookingsState {
  GuestBookingsLoaded({
    required this.page,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final BookingPage page;
  final bool isLoadingMore;
  final Object? loadMoreError;
}

class GuestBookingsCubit extends Cubit<GuestBookingsState> {
  GuestBookingsCubit(this._repository) : super(GuestBookingsLoading());

  static const pageSize = 20;
  final BookingRepository _repository;
  bool _loading = false;

  Future<void> loadFirstPage() async {
    if (_loading) return;
    _loading = true;
    emit(GuestBookingsLoading());
    try {
      final page = await _repository.getGuestBookings(
        pageNumber: 1,
        pageSize: pageSize,
      );
      if (!isClosed) emit(GuestBookingsLoaded(page: page));
    } catch (error) {
      if (!isClosed) emit(GuestBookingsFailure(error));
    } finally {
      _loading = false;
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (_loading ||
        currentState is! GuestBookingsLoaded ||
        !currentState.page.hasNextPage) {
      return;
    }
    _loading = true;
    emit(GuestBookingsLoaded(page: currentState.page, isLoadingMore: true));
    try {
      final nextPage = await _repository.getGuestBookings(
        pageNumber: currentState.page.pageNumber + 1,
        pageSize: pageSize,
      );
      if (!isClosed) {
        emit(
          GuestBookingsLoaded(
            page: BookingPage(
              items: [...currentState.page.items, ...nextPage.items],
              totalCount: nextPage.totalCount,
              pageNumber: nextPage.pageNumber,
              pageSize: nextPage.pageSize,
              totalPages: nextPage.totalPages,
              hasNextPage: nextPage.hasNextPage,
              hasPreviousPage: nextPage.hasPreviousPage,
            ),
          ),
        );
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          GuestBookingsLoaded(page: currentState.page, loadMoreError: error),
        );
      }
    } finally {
      _loading = false;
    }
  }
}

sealed class BookingDetailsState {}

final class BookingDetailsLoading extends BookingDetailsState {}

final class BookingDetailsFailure extends BookingDetailsState {
  BookingDetailsFailure(this.error);

  final Object error;
}

final class BookingDetailsLoaded extends BookingDetailsState {
  BookingDetailsLoaded(
    this.booking, {
    this.uploadProgress,
    this.uploading = false,
    this.uploadError,
    this.receiptSubmitted = false,
  });

  final BookingDetails booking;
  final double? uploadProgress;
  final bool uploading;
  final Object? uploadError;
  final bool receiptSubmitted;
}

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  BookingDetailsCubit(this._repository) : super(BookingDetailsLoading());

  final BookingRepository _repository;
  bool _uploading = false;

  Future<void> load(String bookingId) async {
    if (_uploading) return;
    emit(BookingDetailsLoading());
    try {
      final booking = await _repository.getBookingDetails(bookingId);
      if (!isClosed) emit(BookingDetailsLoaded(booking));
    } catch (error) {
      if (!isClosed) emit(BookingDetailsFailure(error));
    }
  }

  Future<bool> submitReceipt({
    required String bookingId,
    required String filePath,
    required String fileName,
  }) async {
    if (_uploading) return false;
    final current = state;
    if (current is BookingDetailsLoaded) {
      _uploading = true;
      emit(
        BookingDetailsLoaded(
          current.booking,
          uploading: true,
          uploadProgress: 0,
        ),
      );
    } else {
      return false;
    }

    try {
      final booking = await _repository.submitPaymentReceipt(
        bookingId: bookingId,
        filePath: filePath,
        fileName: fileName,
        onSendProgress: (sent, total) {
          if (!isClosed && total > 0) {
            final loaded = state;
            if (loaded is BookingDetailsLoaded) {
              emit(
                BookingDetailsLoaded(
                  loaded.booking,
                  uploading: true,
                  uploadProgress: sent / total,
                ),
              );
            }
          }
        },
      );
      if (!isClosed) {
        emit(
          BookingDetailsLoaded(
            booking,
            uploadProgress: 1,
            receiptSubmitted: true,
          ),
        );
      }
      return true;
    } catch (error) {
      final loaded = state;
      if (!isClosed && loaded is BookingDetailsLoaded) {
        emit(
          BookingDetailsLoaded(
            loaded.booking,
            uploadError: error,
          ),
        );
      }
      return false;
    } finally {
      _uploading = false;
    }
  }
}
