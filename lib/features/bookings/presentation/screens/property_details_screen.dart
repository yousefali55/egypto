import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/auth/login/persentation/cubit/login_cubit.dart';
import 'package:egypto/features/auth/login/persentation/login_screen.dart';
import 'package:egypto/features/bookings/data/models/booking_models.dart';
import 'package:egypto/features/bookings/data/models/property_details.dart';
import 'package:egypto/features/bookings/presentation/cubit/guest_booking_cubit.dart';
import 'package:egypto/features/bookings/presentation/screens/payment_receipt_screen.dart';
import 'package:egypto/features/home/data/models/search_properties_page.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_verification_cubit.dart';
import 'package:egypto/features/my_account/screens/identity_verification_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({
    super.key,
    required this.property,
    required this.profile,
    required this.onProfileChanged,
  });

  final SearchProperty property;
  final UserProfileModel? profile;
  final ValueChanged<UserProfileModel> onProfileChanged;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<GuestBookingCubit>()..loadProperty(property.id),
    child: _PropertyDetailsView(
      property: property,
      profile: profile,
      onProfileChanged: onProfileChanged,
    ),
  );
}

class _PropertyDetailsView extends StatefulWidget {
  const _PropertyDetailsView({
    required this.property,
    required this.profile,
    required this.onProfileChanged,
  });

  final SearchProperty property;
  final UserProfileModel? profile;
  final ValueChanged<UserProfileModel> onProfileChanged;

  @override
  State<_PropertyDetailsView> createState() => _PropertyDetailsViewState();
}

class _PropertyDetailsViewState extends State<_PropertyDetailsView> {
  UserProfileModel? _profile;
  DateTime? _checkIn;
  DateTime? _checkOut;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  @override
  void didUpdateWidget(covariant _PropertyDetailsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) _profile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<GuestBookingCubit, BookingFlowState>(
      listener: (context, state) {
        if (state is BookingCreated) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(S.of(context).bookingCreatedMessage)),
            );
        }
      },
      builder: (context, state) {
        if (state is BookingCreated) {
          return _BookingConfirmationView(
            property: widget.property,
            booking: state.booking,
          );
        }
        if (state is BookingFlowLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is BookingFlowFailure && state.property == null) {
          return Scaffold(
            appBar: AppBar(),
            body: _BookingErrorView(
              message: _errorMessage(context, state.error),
              onRetry: () => context.read<GuestBookingCubit>().loadProperty(
                widget.property.id,
              ),
            ),
          );
        }

        final property = state is BookingPropertyLoaded
            ? state.property
            : state is BookingCreating
            ? state.property
            : state is BookingFlowFailure
            ? state.property
            : null;
        if (property == null) {
          return Scaffold(
            appBar: AppBar(),
            body: _BookingErrorView(
              message: S.of(context).bookingGenericError,
              onRetry: () => context.read<GuestBookingCubit>().loadProperty(
                widget.property.id,
              ),
            ),
          );
        }

        final isCreating = state is BookingCreating;
        final failure = state is BookingFlowFailure ? state.error : null;
        return Scaffold(
          appBar: AppBar(title: Text(S.of(context).propertyDetailsTitle)),
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 30.h),
                  children: [
                    _PropertyImage(
                      property: property,
                      fallback: widget.property,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      property.title.isEmpty
                          ? widget.property.title
                          : property.title,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (property.city?.isNotEmpty == true ||
                        widget.property.city?.isNotEmpty == true) ...[
                      SizedBox(height: 6.h),
                      Text(
                        _location(property, widget.property)!,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                    if (property.address?.isNotEmpty == true) ...[
                      SizedBox(height: 5.h),
                      Text(
                        property.address!,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                    if (property.description?.isNotEmpty == true) ...[
                      SizedBox(height: 14.h),
                      Text(
                        property.description!,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          height: 1.5,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                    if (property.guests != null) ...[
                      SizedBox(height: 10.h),
                      Text(
                        S.of(context).propertyCapacity(property.guests!),
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                    SizedBox(height: 22.h),
                    _sectionTitle(context, S.of(context).bookingDatesLabel),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: _dateButton(
                            context,
                            S.of(context).checkInDate,
                            _checkIn,
                            () => _selectCheckIn(context),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _dateButton(
                            context,
                            S.of(context).checkOutDate,
                            _checkOut,
                            () => _selectCheckOut(context),
                          ),
                        ),
                      ],
                    ),
                    if (_checkIn != null && _checkOut != null) ...[
                      SizedBox(height: 12.h),
                      Text(
                        S
                            .of(context)
                            .bookingNights(
                              _bookingNights(_checkIn!, _checkOut!),
                            ),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                    if (property.nightlyPrice != null ||
                        widget.property.nightlyPrice > 0) ...[
                      SizedBox(height: 9.h),
                      Text(
                        '${S.of(context).egp} ${_money(context, property.nightlyPrice ?? widget.property.nightlyPrice)} / ${S.of(context).night}',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                    if (failure != null) ...[
                      SizedBox(height: 14.h),
                      _BookingFailureMessage(
                        error: failure,
                        onIdentityVerification: _openIdentityVerification,
                      ),
                    ],
                    SizedBox(height: 22.h),
                    _bookingAction(context, property, isCreating),
                  ],
                ),
                if (isCreating)
                  Positioned.fill(
                    child: ColoredBox(
                      color: theme.scaffoldBackgroundColor.withValues(
                        alpha: 0.65,
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bookingAction(
    BuildContext context,
    PropertyDetails property,
    bool isCreating,
  ) {
    final profile = _profile;
    return FilledButton(
      onPressed: isCreating
          ? null
          : () async {
              if (profile == null) {
                await _requireLogin(context);
                return;
              }
              if (profile.isAdmin) {
                _showMessage(S.of(context).guestBookingOnly);
                return;
              }
              if (profile.identityVerificationStatus?.toLowerCase() !=
                  'verified') {
                await _openIdentityVerification();
                return;
              }
              if (!await _validateDates(context)) return;
              if (!context.mounted) return;
              final confirmed = await _confirmBooking(context, property);
              if (confirmed != true || !context.mounted) return;
              await context.read<GuestBookingCubit>().createBooking(
                propertyId: property.id,
                checkInDate: _checkIn!,
                checkOutDate: _checkOut!,
              );
            },
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.darkGlow,
        padding: EdgeInsets.symmetric(vertical: 15.h),
      ),
      child: Text(
        profile == null
            ? S.of(context).loginToBook
            : profile.identityVerificationStatus?.toLowerCase() != 'verified'
            ? S.of(context).completeIdentityVerification
            : S.of(context).requestBooking,
      ),
    );
  }

  Future<void> _selectCheckIn(BuildContext context) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selected = await showDatePicker(
      context: context,
      initialDate: _checkIn != null && !_checkIn!.isBefore(today)
          ? _checkIn!
          : today,
      firstDate: today,
      lastDate: DateTime(today.year + 2),
    );
    if (selected == null) return;
    setState(() {
      _checkIn = selected;
      if (_checkOut != null && !_checkOut!.isAfter(selected)) {
        _checkOut = null;
      }
    });
  }

  Future<void> _selectCheckOut(BuildContext context) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final firstDate = _checkIn == null
        ? today
        : DateTime(_checkIn!.year, _checkIn!.month, _checkIn!.day + 1);
    final lastDate = _checkIn == null
        ? DateTime(today.year + 2)
        : DateTime(_checkIn!.year, _checkIn!.month, _checkIn!.day + 30);
    final selected = await showDatePicker(
      context: context,
      initialDate:
          _checkOut != null &&
              !_checkOut!.isBefore(firstDate) &&
              !_checkOut!.isAfter(lastDate)
          ? _checkOut!
          : firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (selected == null) return;
    setState(() => _checkOut = selected);
  }

  Future<bool> _validateDates(BuildContext context) async {
    final strings = S.of(context);
    final today = DateUtils.dateOnly(DateTime.now());
    if (_checkIn == null || _checkOut == null) {
      _showMessage(strings.selectBookingDates);
      return false;
    }
    if (_checkIn!.isBefore(today)) {
      _showMessage(strings.bookingCheckInPast);
      return false;
    }
    final nights = _bookingNights(_checkIn!, _checkOut!);
    if (nights < 1 || nights > 30) {
      _showMessage(strings.bookingStayLengthInvalid);
      return false;
    }
    return true;
  }

  Future<bool?> _confirmBooking(
    BuildContext context,
    PropertyDetails property,
  ) => showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(S.of(dialogContext).confirmBookingTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(property.title),
          SizedBox(height: 10.h),
          Text(
            '${S.of(dialogContext).checkInDate}: ${_formatDate(context, _checkIn!)}',
          ),
          Text(
            '${S.of(dialogContext).checkOutDate}: ${_formatDate(context, _checkOut!)}',
          ),
          SizedBox(height: 8.h),
          Text(
            S
                .of(dialogContext)
                .bookingNights(_bookingNights(_checkIn!, _checkOut!)),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(S.of(dialogContext).cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(S.of(dialogContext).confirmBooking),
        ),
      ],
    ),
  );

  Future<void> _requireLogin(BuildContext context) async {
    final loggedIn = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => getIt<LoginCubit>(),
          child: const LoginScreen(),
        ),
      ),
    );
    if (!context.mounted || loggedIn != true) return;
    try {
      final profile = await getIt<ApiService>().getProfile();
      if (!context.mounted) return;
      _profile = profile;
      widget.onProfileChanged(profile);
      setState(() {});
    } on Object {
      if (!context.mounted) return;
      _showMessage(S.of(context).profileRefreshError);
    }
  }

  Future<void> _openIdentityVerification() async {
    final status = _profile?.identityVerificationStatus;
    final submitted = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => getIt<IdentityVerificationCubit>(),
          child: IdentityVerificationScreen(currentStatus: status),
        ),
      ),
    );
    if (!context.mounted || submitted != true) return;
    try {
      final profile = await getIt<ApiService>().getProfile();
      if (!context.mounted) return;
      _profile = profile;
      widget.onProfileChanged(profile);
      setState(() {});
    } on Object {
      if (!mounted) return;
      _showMessage(S.of(context).profileRefreshError);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _BookingConfirmationView extends StatelessWidget {
  const _BookingConfirmationView({
    required this.property,
    required this.booking,
  });

  final SearchProperty property;
  final BookingDetails booking;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    final snapshot = booking.financialSnapshot;
    return Scaffold(
      appBar: AppBar(title: Text(strings.bookingConfirmationTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: theme.colorScheme.primary,
            size: 60.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            strings.bookingCreatedMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 22.h),
          _summaryCard(
            context,
            title: booking.propertyTitle.isEmpty
                ? property.title
                : booking.propertyTitle,
            rows: [
              _SummaryRow(
                strings.checkInDate,
                _formatMaybeDate(context, booking.checkInDate),
              ),
              _SummaryRow(
                strings.checkOutDate,
                _formatMaybeDate(context, booking.checkOutDate),
              ),
              if (snapshot.numberOfNights != null)
                _SummaryRow(
                  strings.bookingNightsLabel,
                  snapshot.numberOfNights.toString(),
                ),
              if (snapshot.nightlyPrice != null)
                _SummaryRow(
                  strings.nightlyPriceLabel,
                  _money(context, snapshot.nightlyPrice!),
                ),
              if (snapshot.grossAmount != null)
                _SummaryRow(
                  strings.grossAmountLabel,
                  _money(context, snapshot.grossAmount!),
                ),
              if (snapshot.serviceFee != null)
                _SummaryRow(
                  strings.serviceFeeLabel,
                  _money(context, snapshot.serviceFee!),
                ),
              if (snapshot.hostAmount != null)
                _SummaryRow(
                  strings.hostAmountLabel,
                  _money(context, snapshot.hostAmount!),
                ),
              if (booking.status?.isNotEmpty == true)
                _SummaryRow(
                  strings.bookingStatusLabel,
                  _bookingStatusLabel(context, booking.status!),
                ),
              if (booking.paymentStatus?.isNotEmpty == true)
                _SummaryRow(
                  strings.paymentStatusLabel,
                  _paymentStatusLabel(context, booking.paymentStatus!),
                ),
              if (booking.expiresAt != null)
                _SummaryRow(
                  strings.bookingExpiresAt,
                  _formatDateTime(context, booking.expiresAt!),
                ),
            ],
          ),
          SizedBox(height: 22.h),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider(
                  create: (_) => getIt<BookingDetailsCubit>()..load(booking.id),
                  child: PaymentReceiptScreen(booking: booking),
                ),
              ),
            ),
            icon: const Icon(Icons.receipt_long_rounded),
            label: Text(strings.paymentUploadButton),
          ),
          SizedBox(height: 10.h),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(strings.done),
          ),
        ],
      ),
    );
  }
}

class _PropertyImage extends StatelessWidget {
  const _PropertyImage({required this.property, required this.fallback});

  final PropertyDetails property;
  final SearchProperty fallback;

  @override
  Widget build(BuildContext context) {
    final source = property.coverImageUrl ?? fallback.coverImageUrl;
    final url = ApiConstants.resolveUploadUrl(source);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: SizedBox(
        height: 230.h,
        child: url == null
            ? ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(Icons.apartment_rounded, size: 54.sp),
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.apartment_rounded, size: 54.sp),
                ),
              ),
      ),
    );
  }
}

class _BookingFailureMessage extends StatelessWidget {
  const _BookingFailureMessage({
    required this.error,
    required this.onIdentityVerification,
  });

  final Object error;
  final VoidCallback onIdentityVerification;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final failure = error is BookingApiException
        ? error as BookingApiException
        : null;
    final code = failure?.code;
    final message = switch (code) {
      'IdentityNotVerified' => strings.identityNotVerifiedForBooking,
      'DatesUnavailable' => strings.bookingDatesUnavailable,
      'PaymentFailed' => strings.bookingPaymentFailed,
      'ValidationFailed' => strings.bookingValidationFailed,
      _ when failure?.statusCode == 403 => strings.bookingUnauthorized,
      _ when failure?.statusCode == 409 => strings.bookingDatesUnavailable,
      _ when failure?.statusCode == 400 => strings.bookingValidationFailed,
      _ => strings.bookingGenericError,
    };
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (code == 'IdentityNotVerified')
              TextButton(
                onPressed: onIdentityVerification,
                child: Text(strings.completeIdentityVerification),
              ),
          ],
        ),
      ),
    );
  }
}

class _BookingErrorView extends StatelessWidget {
  const _BookingErrorView({required this.message, required this.onRetry});

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

Widget _dateButton(
  BuildContext context,
  String label,
  DateTime? date,
  VoidCallback onTap,
) {
  final theme = Theme.of(context);
  return OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      alignment: AlignmentDirectional.centerStart,
      foregroundColor: theme.colorScheme.onSurface,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
      side: BorderSide(color: theme.colorScheme.outlineVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11.sp)),
        SizedBox(height: 4.h),
        Text(
          date == null ? S.of(context).selectDate : _formatDate(context, date),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12.sp),
        ),
      ],
    ),
  );
}

Widget _sectionTitle(BuildContext context, String label) => Text(
  label,
  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
);

Widget _summaryCard(
  BuildContext context, {
  required String title,
  required List<_SummaryRow> rows,
}) => Card(
  child: Padding(
    padding: EdgeInsets.all(16.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10.h),
        for (final row in rows) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(child: Text(row.label)),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    row.value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          if (row != rows.last) const Divider(height: 1),
        ],
      ],
    ),
  ),
);

class _SummaryRow {
  const _SummaryRow(this.label, this.value);

  final String label;
  final String value;
}

String? _location(PropertyDetails property, SearchProperty fallback) {
  final values = [
    property.city ?? fallback.city,
    property.address,
  ].whereType<String>().where((value) => value.isNotEmpty);
  return values.isEmpty ? null : values.join(' · ');
}

int _bookingNights(DateTime checkIn, DateTime checkOut) => DateTime.utc(
  checkOut.year,
  checkOut.month,
  checkOut.day,
).difference(DateTime.utc(checkIn.year, checkIn.month, checkIn.day)).inDays;

String _formatDate(BuildContext context, DateTime date) =>
    intl.DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
        .format(date);

String _formatMaybeDate(BuildContext context, DateTime? date) =>
    date == null ? S.of(context).notAvailable : _formatDate(context, date);

String _formatDateTime(BuildContext context, DateTime date) =>
    intl.DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
        .add_jm()
        .format(date.toLocal());

String _money(BuildContext context, double amount) => intl.NumberFormat(
  '#,##0.##',
  Localizations.localeOf(context).toLanguageTag(),
).format(amount);

String _bookingStatusLabel(BuildContext context, String status) =>
    switch (status.toLowerCase()) {
      'pending' => S.of(context).bookingPending,
      'confirmed' => S.of(context).bookingConfirmed,
      'rejected' => S.of(context).bookingRejected,
      _ => status,
    };

String _paymentStatusLabel(BuildContext context, String status) =>
    switch (status.toLowerCase()) {
      'held' => S.of(context).paymentHeld,
      'refunded' => S.of(context).paymentRefunded,
      _ => status,
    };

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
      AppErrorType.notFound => strings.bookingNotFound,
      _ => strings.bookingGenericError,
    };
  }
  return strings.bookingGenericError;
}
