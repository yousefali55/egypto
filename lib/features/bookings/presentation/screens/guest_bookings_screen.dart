import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/bookings/data/models/booking_models.dart';
import 'package:egypto/features/bookings/presentation/cubit/guest_booking_cubit.dart';
import 'package:egypto/features/bookings/presentation/screens/payment_receipt_screen.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class GuestBookingsScreen extends StatelessWidget {
  const GuestBookingsScreen({super.key, required this.profile});

  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<GuestBookingsCubit>()..loadFirstPage(),
    child: _GuestBookingsView(profile: profile),
  );
}

class _GuestBookingsView extends StatelessWidget {
  const _GuestBookingsView({required this.profile});

  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    if (profile.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.guestBookingsTitle)),
        body: Center(child: Text(strings.guestBookingsUnauthorized)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(strings.guestBookingsTitle)),
      body: SafeArea(
        child: BlocBuilder<GuestBookingsCubit, GuestBookingsState>(
          builder: (context, state) => switch (state) {
            GuestBookingsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            GuestBookingsFailure(:final error) => _BookingsLoadError(
              message: _errorMessage(context, error),
              onRetry: () => context.read<GuestBookingsCubit>().loadFirstPage(),
            ),
            GuestBookingsLoaded(
              :final page,
              :final isLoadingMore,
              :final loadMoreError,
            ) =>
              page.items.isEmpty
                  ? Center(child: Text(strings.noGuestBookings))
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<GuestBookingsCubit>().loadFirstPage(),
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
                        itemCount:
                            page.items.length +
                            (page.hasNextPage ||
                                    isLoadingMore ||
                                    loadMoreError != null
                                ? 1
                                : 0),
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          if (index < page.items.length) {
                            final booking = page.items[index];
                            return _GuestBookingCard(
                              booking: booking,
                              onTap: () => Navigator.of(context).push<void>(
                                MaterialPageRoute<void>(
                                  builder: (_) => BookingDetailScreen(
                                    bookingId: booking.id,
                                    profile: profile,
                                  ),
                                ),
                              ),
                            );
                          }
                          if (loadMoreError != null) {
                            return TextButton.icon(
                              onPressed: () => context
                                  .read<GuestBookingsCubit>()
                                  .loadNextPage(),
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text(strings.retry),
                            );
                          }
                          if (isLoadingMore) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Center(
                            child: TextButton.icon(
                              onPressed: () => context
                                  .read<GuestBookingsCubit>()
                                  .loadNextPage(),
                              icon: const Icon(Icons.expand_more_rounded),
                              label: Text(strings.loadMore),
                            ),
                          );
                        },
                      ),
                    ),
          },
        ),
      ),
    );
  }
}

class _GuestBookingCard extends StatelessWidget {
  const _GuestBookingCard({required this.booking, required this.onTap});

  final BookingDetails booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.propertyTitle.isEmpty
                          ? strings.propertyDetailsTitle
                          : booking.propertyTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _StatusChip(status: booking.status),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                '${strings.checkInDate}: ${_date(context, booking.checkInDate)}',
              ),
              SizedBox(height: 4.h),
              Text(
                '${strings.checkOutDate}: ${_date(context, booking.checkOutDate)}',
              ),
              if (booking.financialSnapshot.grossAmount != null) ...[
                SizedBox(height: 8.h),
                Text(
                  '${strings.grossAmountLabel}: ${_money(context, booking.financialSnapshot.grossAmount!)} ${strings.egp}',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
              if (booking.createdAt != null) ...[
                SizedBox(height: 5.h),
                Text(
                  '${strings.bookingCreatedAt}: ${_date(context, booking.createdAt)}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                ),
              ],
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({
    super.key,
    required this.bookingId,
    required this.profile,
  });

  final String bookingId;
  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) => profile.isAdmin
      ? Scaffold(
          appBar: AppBar(title: Text(S.of(context).bookingDetailsTitle)),
          body: Center(child: Text(S.of(context).guestBookingsUnauthorized)),
        )
      : BlocProvider(
          create: (_) => getIt<BookingDetailsCubit>()..load(bookingId),
          child: Scaffold(
            appBar: AppBar(title: Text(S.of(context).bookingDetailsTitle)),
            body: SafeArea(
              child: BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
                builder: (context, state) => switch (state) {
                  BookingDetailsLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  BookingDetailsFailure(:final error) => _BookingsLoadError(
                    message: _errorMessage(context, error),
                    onRetry: () =>
                        context.read<BookingDetailsCubit>().load(bookingId),
                  ),
                  BookingDetailsLoaded(:final booking) => _BookingDetailContent(
                    booking: booking,
                  ),
                },
              ),
            ),
          ),
        );
}

class _BookingDetailContent extends StatelessWidget {
  const _BookingDetailContent({required this.booking});

  final BookingDetails booking;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final snapshot = booking.financialSnapshot;
    return ListView(
      padding: EdgeInsets.all(18.r),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.propertyTitle.isEmpty
                      ? strings.propertyDetailsTitle
                      : booking.propertyTitle,
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (booking.propertyAddress?.isNotEmpty == true) ...[
                  SizedBox(height: 5.h),
                  Text(booking.propertyAddress!),
                ],
                SizedBox(height: 14.h),
                _BookingValueRow(
                  strings.checkInDate,
                  _date(context, booking.checkInDate),
                ),
                _BookingValueRow(
                  strings.checkOutDate,
                  _date(context, booking.checkOutDate),
                ),
                if (snapshot.numberOfNights != null)
                  _BookingValueRow(
                    strings.bookingNightsLabel,
                    snapshot.numberOfNights.toString(),
                  ),
                _BookingValueRow(
                  strings.bookingStatusLabel,
                  _bookingStatus(context, booking.status),
                ),
                _BookingValueRow(
                  strings.paymentStatusLabel,
                  _paymentStatus(context, booking.paymentStatus),
                ),
                if (booking.createdAt != null)
                  _BookingValueRow(
                    strings.bookingCreatedAt,
                    _date(context, booking.createdAt),
                  ),
                if (booking.decidedAt != null)
                  _BookingValueRow(
                    strings.bookingDecidedAt,
                    _date(context, booking.decidedAt),
                  ),
                if (booking.expiresAt != null)
                  _BookingValueRow(
                    strings.bookingExpiresAt,
                    _dateTime(context, booking.expiresAt!),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.financialSnapshotTitle,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (snapshot.nightlyPrice != null)
                  _BookingValueRow(
                    strings.nightlyPriceLabel,
                    _money(context, snapshot.nightlyPrice!),
                  ),
                if (snapshot.numberOfNights != null)
                  _BookingValueRow(
                    strings.bookingNightsLabel,
                    snapshot.numberOfNights.toString(),
                  ),
                if (snapshot.grossAmount != null)
                  _BookingValueRow(
                    strings.grossAmountLabel,
                    _money(context, snapshot.grossAmount!),
                  ),
                if (snapshot.serviceFee != null)
                  _BookingValueRow(
                    strings.serviceFeeLabel,
                    _money(context, snapshot.serviceFee!),
                  ),
                if (snapshot.hostAmount != null)
                  _BookingValueRow(
                    strings.hostAmountLabel,
                    _money(context, snapshot.hostAmount!),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        if (!(_receiptSubmitted(booking) &&
            booking.resubmissionAllowed != true))
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider.value(
                  value: context.read<BookingDetailsCubit>(),
                  child: PaymentReceiptScreen(booking: booking),
                ),
              ),
            ),
            icon: const Icon(Icons.receipt_long_rounded),
            label: Text(S.of(context).paymentUploadButton),
          ),
      ],
    );
  }
}

class _BookingValueRow extends StatelessWidget {
  const _BookingValueRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 7.h),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final label = _bookingStatus(context, status);
    final color = status?.toLowerCase() == 'rejected'
        ? Theme.of(context).colorScheme.error
        : AppColors.darkGlow;
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
      labelStyle: TextStyle(color: color, fontSize: 11.sp),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _BookingsLoadError extends StatelessWidget {
  const _BookingsLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 12.h),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(S.of(context).retry),
          ),
        ],
      ),
    ),
  );
}

String _date(BuildContext context, DateTime? value) => value == null
    ? S.of(context).notAvailable
    : intl.DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
          .format(value);

String _dateTime(BuildContext context, DateTime value) =>
    intl.DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
        .add_jm()
        .format(value.toLocal());

String _money(BuildContext context, double value) => intl.NumberFormat(
  '#,##0.##',
  Localizations.localeOf(context).toLanguageTag(),
).format(value);

String _bookingStatus(BuildContext context, String? status) =>
    switch (status?.toLowerCase()) {
      'pending' => S.of(context).bookingPending,
      'confirmed' => S.of(context).bookingConfirmed,
      'rejected' => S.of(context).bookingRejected,
      _ => status ?? S.of(context).notAvailable,
    };

String _paymentStatus(BuildContext context, String? status) =>
    switch (status?.toLowerCase()) {
      'held' => S.of(context).paymentHeld,
      'refunded' => S.of(context).paymentRefunded,
      _ => status ?? S.of(context).notAvailable,
    };

bool _receiptSubmitted(BookingDetails booking) {
  if (booking.paymentReceiptSubmitted == true) return true;
  final status = booking.paymentReceiptStatus?.trim().toLowerCase();
  return status != null &&
      {'submitted', 'pending', 'pendingreview', 'waitingreview', 'underreview'}
          .contains(status);
}

String _errorMessage(BuildContext context, Object error) {
  final strings = S.of(context);
  if (error is BookingApiException) {
    return switch (error.statusCode) {
      403 => strings.bookingUnauthorized,
      404 => strings.bookingNotFound,
      _ => strings.bookingGenericError,
    };
  }
  if (error is AppException) {
    return switch (error.errorType) {
      AppErrorType.network ||
      AppErrorType.timeout => strings.bookingNetworkError,
      AppErrorType.unauthorized => strings.bookingUnauthorized,
      AppErrorType.forbidden => strings.bookingUnauthorized,
      AppErrorType.notFound => strings.bookingNotFound,
      _ => strings.bookingGenericError,
    };
  }
  return strings.bookingGenericError;
}
