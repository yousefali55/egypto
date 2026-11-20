import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/bookings/data/models/booking_models.dart';
import 'package:egypto/features/bookings/presentation/cubit/host_bookings_cubit.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class HostBookingsScreen extends StatelessWidget {
  const HostBookingsScreen({super.key, required this.profile});

  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    if (!profile.isHost || profile.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text(S.of(context).hostBookingsTitle)),
        body: Center(child: Text(S.of(context).hostBookingsUnauthorized)),
      );
    }
    return BlocProvider(
      create: (_) => getIt<HostBookingsCubit>()..loadFirstPage(),
      child: const _HostBookingsView(),
    );
  }
}

class _HostBookingsView extends StatefulWidget {
  const _HostBookingsView();

  @override
  State<_HostBookingsView> createState() => _HostBookingsViewState();
}

class _HostBookingsViewState extends State<_HostBookingsView> {
  BookingDecisionResponse? _shownDecision;
  Object? _shownError;

  @override
  Widget build(
    BuildContext context,
  ) => BlocListener<HostBookingsCubit, HostBookingsState>(
    listenWhen: (_, state) =>
        state is HostBookingsLoaded &&
        ((state.lastDecision != null &&
                !identical(state.lastDecision, _shownDecision)) ||
            (state.operationError != null &&
                !identical(state.operationError, _shownError))),
    listener: (context, state) {
      if (state is! HostBookingsLoaded) return;
      if (state.operationError != null &&
          !identical(state.operationError, _shownError)) {
        _shownError = state.operationError;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(_errorMessage(context, state.operationError!)),
            ),
          );
        return;
      }
      if (state.lastDecision == null) return;
      _shownDecision = state.lastDecision;
      final decision = state.lastDecision!;
      final status = _bookingStatus(context, decision.status);
      final payment = _paymentStatus(context, decision.paymentStatus);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(S.of(context).hostDecisionSuccess(status, payment)),
          ),
        );
    },
    child: Scaffold(
      appBar: AppBar(title: Text(S.of(context).hostBookingsTitle)),
      body: SafeArea(
        child: BlocBuilder<HostBookingsCubit, HostBookingsState>(
          builder: (context, state) => switch (state) {
            HostBookingsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            HostBookingsFailure(:final error) => _HostBookingsError(
              message: _errorMessage(context, error),
              onRetry: () => context.read<HostBookingsCubit>().loadFirstPage(),
            ),
            HostBookingsLoaded(
              :final page,
              :final isLoadingMore,
              :final loadMoreError,
              :final actingBookingId,
            ) =>
              page.items.isEmpty
                  ? RefreshIndicator(
                      onRefresh: () =>
                          context.read<HostBookingsCubit>().loadFirstPage(),
                      child: ListView(
                        padding: EdgeInsets.all(24.r),
                        children: [
                          SizedBox(height: 130.h),
                          Center(
                            child: loadMoreError == null
                                ? Text(S.of(context).noHostBookings)
                                : Column(
                                    children: [
                                      Text(
                                        _errorMessage(context, loadMoreError),
                                        textAlign: TextAlign.center,
                                      ),
                                      TextButton(
                                        onPressed: () => context
                                            .read<HostBookingsCubit>()
                                            .loadFirstPage(),
                                        child: Text(S.of(context).retry),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<HostBookingsCubit>().loadFirstPage(),
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
                            final request = page.items[index];
                            final isActing = actingBookingId == request.id;
                            return _HostRequestCard(
                              request: request,
                              isActing: isActing,
                              actionsDisabled: actingBookingId != null,
                              onAccept: () => _confirmDecision(
                                context,
                                request,
                                accept: true,
                              ),
                              onReject: () => _confirmDecision(
                                context,
                                request,
                                accept: false,
                              ),
                            );
                          }
                          if (loadMoreError != null) {
                            return TextButton.icon(
                              onPressed: () {
                                final cubit = context.read<HostBookingsCubit>();
                                if (page.hasNextPage) {
                                  cubit.loadNextPage();
                                } else {
                                  cubit.loadFirstPage();
                                }
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text(S.of(context).retry),
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
                                  .read<HostBookingsCubit>()
                                  .loadNextPage(),
                              icon: const Icon(Icons.expand_more_rounded),
                              label: Text(S.of(context).loadMore),
                            ),
                          );
                        },
                      ),
                    ),
          },
        ),
      ),
    ),
  );

  Future<void> _confirmDecision(
    BuildContext context,
    HostBookingRequest request, {
    required bool accept,
  }) async {
    final strings = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          accept ? strings.acceptBookingTitle : strings.rejectBookingTitle,
        ),
        content: Text(
          accept
              ? strings.acceptBookingConfirmation
              : strings.rejectBookingConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: accept
                ? null
                : FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
            child: Text(accept ? strings.acceptBooking : strings.rejectBooking),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    final cubit = context.read<HostBookingsCubit>();
    if (accept) {
      await cubit.accept(request.id);
    } else {
      await cubit.reject(request.id);
    }
  }
}

class _HostRequestCard extends StatelessWidget {
  const _HostRequestCard({
    required this.request,
    required this.isActing,
    required this.actionsDisabled,
    required this.onAccept,
    required this.onReject,
  });

  final HostBookingRequest request;
  final bool isActing;
  final bool actionsDisabled;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.propertyTitle,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4.h),
            Text('${strings.guestNameLabel}: ${request.guestName}'),
            SizedBox(height: 8.h),
            Text(
              '${strings.checkInDate}: ${_date(context, request.checkInDate)}',
            ),
            SizedBox(height: 4.h),
            Text(
              '${strings.checkOutDate}: ${_date(context, request.checkOutDate)}',
            ),
            if (request.grossAmount != null) ...[
              SizedBox(height: 8.h),
              Text(
                '${strings.grossAmountLabel}: ${_money(context, request.grossAmount!)} ${strings.egp}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
            if (request.createdAt != null) ...[
              SizedBox(height: 4.h),
              Text(
                '${strings.bookingCreatedAt}: ${_dateTime(context, request.createdAt!)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
            ],
            if (request.hoursRemaining != null) ...[
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: AppColors.darkGlow,
                    size: 17.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    strings.bookingHoursRemaining(
                      _hoursText(context, request.hoursRemaining!),
                    ),
                    style: TextStyle(
                      color: AppColors.darkGlow,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: actionsDisabled ? null : onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: Text(strings.rejectBooking),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: FilledButton(
                    onPressed: actionsDisabled ? null : onAccept,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.darkGlow,
                    ),
                    child: isActing
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(strings.acceptBooking),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HostBookingsError extends StatelessWidget {
  const _HostBookingsError({required this.message, required this.onRetry});

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

String _hoursText(BuildContext context, double hours) => intl.NumberFormat(
  '#,##0.0',
  Localizations.localeOf(context).toLanguageTag(),
).format(hours);

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

String _errorMessage(BuildContext context, Object error) {
  final strings = S.of(context);
  if (error is BookingApiException) {
    return switch (error.code) {
      'UnauthorizedAction' => strings.bookingUnauthorized,
      'InvalidStateTransition' => strings.bookingStateNoLongerValid,
      'ResourceNotFound' => strings.bookingNotFound,
      _ => switch (error.statusCode) {
        403 => strings.bookingUnauthorized,
        404 => strings.bookingNotFound,
        _ => strings.bookingGenericError,
      },
    };
  }
  if (error is AppException) {
    return switch (error.errorType) {
      AppErrorType.network ||
      AppErrorType.timeout => strings.bookingNetworkError,
      AppErrorType.unauthorized ||
      AppErrorType.forbidden => strings.bookingUnauthorized,
      AppErrorType.notFound => strings.bookingNotFound,
      _ => strings.bookingGenericError,
    };
  }
  return strings.bookingGenericError;
}
