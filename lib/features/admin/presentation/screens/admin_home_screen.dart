import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/navigation/floating_bottom_nav_bar.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:egypto/features/admin/presentation/widgets/admin_document_image.dart';
import 'package:egypto/features/host_properties/screens/add_property_screen.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/my_account/screens/my_account_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

enum _AdminQueueKind { identity, properties, payments }

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({
    super.key,
    required this.profile,
    required this.onProfileChanged,
  });

  final UserProfileModel profile;
  final ValueChanged<UserProfileModel?> onProfileChanged;

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  void _openQueueDetails(
    BuildContext context,
    _AdminQueueKind kind,
    String id,
  ) async {
    if (kind == _AdminQueueKind.payments) {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => BlocProvider.value(
            value: context.read<AdminCubit>(),
            child: _AdminPaymentReviewScreen(bookingId: id),
          ),
        ),
      );
      return;
    }
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider.value(
          value: context.read<AdminCubit>(),
          child: _AdminReviewDetailsScreen(kind: kind, id: id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => getIt<AdminCubit>()
        ..loadPendingIdentity()
        ..loadPendingProperties()
        ..loadPendingPayments(),
      child: Builder(
        builder: (context) {
          final screens = <Widget>[
            _AdminQueueScreen(
              kind: _AdminQueueKind.identity,
              onOpenDetails: (id) =>
                  _openQueueDetails(context, _AdminQueueKind.identity, id),
            ),
            _AdminQueueScreen(
              kind: _AdminQueueKind.properties,
              onOpenDetails: (id) =>
                  _openQueueDetails(context, _AdminQueueKind.properties, id),
            ),
            _AdminPaymentQueueScreen(
              onOpenDetails: (id) =>
                  _openQueueDetails(context, _AdminQueueKind.payments, id),
            ),
            AddPropertyScreen(
              profile: widget.profile,
              allowAdmin: true,
              onSubmitted: () {
                context.read<AdminCubit>().loadPendingProperties();
                setState(() => _currentIndex = 1);
              },
            ),
            MyAccountScreen(
              isActive: _currentIndex == 4,
              adminMode: true,
              onProfileChanged: widget.onProfileChanged,
            ),
          ];
          return Scaffold(
            body: Stack(
              children: [
                IndexedStack(index: _currentIndex, children: screens),
                Positioned(
                  left: 20.w,
                  right: 20.w,
                  bottom: MediaQuery.paddingOf(context).bottom + 16.h,
                  child: FloatingBottomNavBar(
                    currentIndex: _currentIndex,
                    onItemSelected: (index) =>
                        setState(() => _currentIndex = index),
                    items: [
                      FloatingBottomNavItem(
                        icon: const Icon(Icons.verified_user_outlined),
                        label: strings.adminIdentityTab,
                      ),
                      FloatingBottomNavItem(
                        icon: const Icon(Icons.apartment_rounded),
                        label: strings.adminPendingPropertiesTab,
                      ),
                      FloatingBottomNavItem(
                        icon: const Icon(Icons.receipt_long_rounded),
                        label: strings.adminPendingPaymentsTab,
                      ),
                      FloatingBottomNavItem(
                        icon: const Icon(Icons.add_home_work_outlined),
                        label: strings.addPropertyTitle,
                      ),
                      FloatingBottomNavItem(
                        icon: const Icon(Icons.account_circle_outlined),
                        label: strings.adminProfileTab,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
          );
        },
      ),
    );
  }
}

class _AdminQueueScreen extends StatelessWidget {
  const _AdminQueueScreen({required this.kind, required this.onOpenDetails});

  final _AdminQueueKind kind;
  final ValueChanged<String> onOpenDetails;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final strings = S.of(context);
        final isIdentity = kind == _AdminQueueKind.identity;
        final page = isIdentity ? state.identityPage : state.propertiesPage;
        final loading = isIdentity
            ? state.identityLoading
            : state.propertiesLoading;
        final error = isIdentity ? state.identityError : state.propertiesError;
        final title = isIdentity
            ? strings.adminIdentityTitle
            : strings.adminPropertiesTitle;
        final emptyMessage = isIdentity
            ? strings.adminNoIdentityRequests
            : strings.adminNoPendingProperties;

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: _QueueContent(
            kind: kind,
            page: page,
            loading: loading,
            error: error,
            emptyMessage: emptyMessage,
            onRetry: () => _loadPage(context, kind),
            onRefresh: () => _loadPage(context, kind),
            onLoadMore: () => _loadPage(context, kind, append: true),
            onOpenDetails: onOpenDetails,
          ),
        );
      },
    );
  }

  Future<void> _loadPage(
    BuildContext context,
    _AdminQueueKind kind, {
    bool append = false,
  }) => kind == _AdminQueueKind.identity
      ? context.read<AdminCubit>().loadPendingIdentity(append: append)
      : context.read<AdminCubit>().loadPendingProperties(append: append);
}

class _AdminPaymentQueueScreen extends StatelessWidget {
  const _AdminPaymentQueueScreen({required this.onOpenDetails});

  final ValueChanged<String> onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state.paymentsLoading && state.payments.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(strings.adminPendingPaymentsTab)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state.paymentsError != null && state.payments.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(strings.adminPendingPaymentsTab)),
            body: _AdminErrorView(
              message: _errorMessage(
                context,
                state.paymentsError,
                strings.adminLoadError,
              ),
              onRetry: () =>
                  context.read<AdminCubit>().loadPendingPayments(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(strings.adminPendingPaymentsTab)),
          body: RefreshIndicator(
            onRefresh: () =>
                context.read<AdminCubit>().loadPendingPayments(),
            child: state.payments.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(24.r),
                    children: [
                      SizedBox(height: 300.h),
                      Center(
                        child: Text(strings.adminNoPendingPayments),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 120.h),
                    itemCount: state.payments.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = state.payments[index];
                      final id = item['bookingId']?.toString() ??
                          item['id']?.toString();
                      final guest = _firstString(
                        item,
                        const ['guestName', 'guest', 'guestFullName', 'name'],
                      );
                      final property = _firstString(
                        item,
                        const ['propertyTitle', 'propertyName', 'title'],
                      );
                      final amount = item['amount'] ??
                          item['grossAmount'] ??
                          item['paymentAmount'];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: id == null ? null : () => onOpenDetails(id),
                          child: Padding(
                            padding: EdgeInsets.all(14.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  property ?? strings.adminPendingPaymentsTab,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (guest != null) ...[
                                  SizedBox(height: 5.h),
                                  Text('${strings.guestNameLabel}: $guest'),
                                ],
                                if (amount != null) ...[
                                  SizedBox(height: 5.h),
                                  Text(
                                    '${strings.grossAmountLabel}: $amount ${strings.egp}',
                                  ),
                                ],
                                if (id != null) ...[
                                  SizedBox(height: 5.h),
                                  Text(
                                    '${strings.bookingReferenceLabel}: $id',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

class _AdminPaymentReviewScreen extends StatefulWidget {
  const _AdminPaymentReviewScreen({required this.bookingId});

  final String bookingId;

  @override
  State<_AdminPaymentReviewScreen> createState() =>
      _AdminPaymentReviewScreenState();
}

class _AdminPaymentReviewScreenState
    extends State<_AdminPaymentReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadPaymentReceipt(widget.bookingId);
  }

  Future<bool> _confirmAndReview(bool approve) async {
    final strings = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(approve ? strings.adminApprove : strings.adminReject),
        content: Text(
          approve
              ? strings.adminApproveConfirmation
              : strings.adminRejectConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(approve ? strings.adminApprove : strings.adminReject),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return false;
    final cubit = context.read<AdminCubit>();
    final success = approve
        ? await cubit.approvePayment(widget.bookingId)
        : await cubit.rejectPayment(widget.bookingId);
    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (approve
                    ? strings.adminApproveSuccess
                    : strings.adminRejectSuccess)
              : strings.adminActionError,
        ),
      ),
    );
    if (success) Navigator.of(context).pop(true);
    return success;
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final detail = state.paymentDetail;
        final receiptPath = detail == null
            ? null
            : _firstString(detail, const [
                'receiptUrl',
                'url',
                'viewUrl',
                'fileUrl',
                'path',
                'storageKey',
              ]);
        return Scaffold(
          appBar: AppBar(title: Text(strings.adminPaymentReviewTitle)),
          body: state.paymentDetailLoading
              ? const Center(child: CircularProgressIndicator())
              : state.paymentDetailError != null
              ? _AdminErrorView(
                  message: _errorMessage(
                    context,
                    state.paymentDetailError,
                    strings.adminDetailsError,
                  ),
                  onRetry: () => context
                      .read<AdminCubit>()
                      .loadPaymentReceipt(widget.bookingId),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                        children: [
                          if (detail != null) ...[
                            for (final entry in detail.entries)
                              if (!_isReceiptKey(entry.key) &&
                                  entry.value != null &&
                                  entry.value is! Map &&
                                  entry.value is! List)
                                _DetailValue(
                                  label: entry.key,
                                  value: entry.value.toString(),
                                ),
                          ],
                          if (receiptPath != null) ...[
                            SizedBox(height: 12.h),
                            AdminDocumentImage(
                              label: strings.paymentReceiptLabel,
                              path: receiptPath,
                              loadImage: (path) => context
                                  .read<AdminCubit>()
                                  .loadPaymentReceiptImage(path),
                            ),
                          ] else
                            _DocumentMissingText(
                              message: strings.paymentReceiptMissing,
                            ),
                        ],
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: state.processing
                                    ? null
                                    : () => _confirmAndReview(false),
                                child: Text(strings.adminReject),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: FilledButton(
                                onPressed: state.processing
                                    ? null
                                    : () => _confirmAndReview(true),
                                child: Text(strings.adminApprove),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

bool _isReceiptKey(String key) =>
    const {'receiptUrl', 'url', 'viewUrl', 'fileUrl', 'path', 'storageKey'}
        .contains(key);

class _DocumentMissingText extends StatelessWidget {
  const _DocumentMissingText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 24.h),
    child: Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

class _QueueContent extends StatelessWidget {
  const _QueueContent({
    required this.kind,
    required this.page,
    required this.loading,
    required this.error,
    required this.emptyMessage,
    required this.onRetry,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onOpenDetails,
  });

  final _AdminQueueKind kind;
  final dynamic page;
  final bool loading;
  final Object? error;
  final String emptyMessage;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final ValueChanged<String> onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final items = page?.items as List<Map<String, dynamic>>? ?? const [];
    if (loading && page == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null && page == null) {
      return _AdminErrorView(
        message: _errorMessage(context, error, strings.adminLoadError),
        onRetry: onRetry,
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 120.h),
        children: [
          if (error != null)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                _errorMessage(context, error, strings.adminLoadError),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (items.isEmpty)
            SizedBox(
              height: 340.h,
              child: Center(
                child: Text(
                  emptyMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _PendingRecordTile(
                  kind: kind,
                  record: item,
                  onTap: _recordId(item, kind) == null
                      ? null
                      : () => onOpenDetails(_recordId(item, kind)!),
                ),
              ),
            ),
          if (page?.hasNextPage == true)
            Center(
              child: OutlinedButton.icon(
                onPressed: loading ? null : onLoadMore,
                icon: loading
                    ? SizedBox.square(
                        dimension: 16.sp,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.expand_more_rounded),
                label: Text(strings.loadMore),
              ),
            ),
        ],
      ),
    );
  }
}

class _PendingRecordTile extends StatelessWidget {
  const _PendingRecordTile({
    required this.kind,
    required this.record,
    required this.onTap,
  });

  final _AdminQueueKind kind;
  final Map<String, dynamic> record;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    final isIdentity = kind == _AdminQueueKind.identity;
    final title = _firstString(
      record,
      isIdentity
          ? const ['fullName', 'name', 'email']
          : const ['title', 'name'],
    );
    final fallback = isIdentity
        ? strings.adminIdentityTab
        : strings.adminPendingPropertiesTab;
    final image = _imageEntries(record).firstOrNull;
    final subtitle = _firstString(
      record,
      isIdentity
          ? const ['email', 'identityVerificationStatus', 'status']
          : const ['city', 'status'],
    );
    final price = record['nightlyPrice'];
    final createdAt = record['createdAt'];

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              _RecordImage(path: image?.$2, size: 76.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? fallback,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                    if (price != null || createdAt != null) ...[
                      SizedBox(height: 5.h),
                      Text(
                        [
                          if (price != null) '$price ${strings.egp}',
                          if (createdAt != null) _formatDate(createdAt),
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminReviewDetailsScreen extends StatefulWidget {
  const _AdminReviewDetailsScreen({required this.kind, required this.id});

  final _AdminQueueKind kind;
  final String id;

  @override
  State<_AdminReviewDetailsScreen> createState() =>
      _AdminReviewDetailsScreenState();
}

class _AdminReviewDetailsScreenState extends State<_AdminReviewDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<AdminCubit>();
    if (widget.kind == _AdminQueueKind.identity) {
      cubit.loadIdentityDetails(widget.id);
    } else {
      cubit.loadPropertyDetails(widget.id);
    }
  }

  Future<void> _review(bool approve) async {
    final strings = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(approve ? strings.adminApprove : strings.adminReject),
        content: Text(
          approve
              ? strings.adminApproveConfirmation
              : strings.adminRejectConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(approve ? strings.adminApprove : strings.adminReject),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final cubit = context.read<AdminCubit>();
    final identity = widget.kind == _AdminQueueKind.identity;
    final succeeded = identity
        ? approve
              ? await cubit.approveIdentity(widget.id)
              : await cubit.rejectIdentity(widget.id)
        : approve
        ? await cubit.approveProperty(widget.id)
        : await cubit.rejectProperty(widget.id);
    if (!mounted) return;
    if (!succeeded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorMessage(
              context,
              cubit.state.actionError,
              S.of(context).adminActionError,
            ),
          ),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          approve
              ? S.of(context).adminApproveSuccess
              : S.of(context).adminRejectSuccess,
        ),
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final title = widget.kind == _AdminQueueKind.identity
        ? strings.identityFlowTitle
        : strings.adminPendingPropertiesTab;
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final detail = state.detail;
        final identityDetails = state.identityDetails;
        final hasDetails = widget.kind == _AdminQueueKind.identity
            ? identityDetails != null
            : detail != null;
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: state.detailLoading
              ? const Center(child: CircularProgressIndicator())
              : !hasDetails
              ? _AdminErrorView(
                  message:
                      state.detailError == AppErrorType.unauthorized ||
                          state.detailError == AppErrorType.forbidden
                      ? strings.adminUnauthorized
                      : strings.adminDetailsError,
                  onRetry: () {
                    if (widget.kind == _AdminQueueKind.identity) {
                      context.read<AdminCubit>().loadIdentityDetails(widget.id);
                    } else {
                      context.read<AdminCubit>().loadPropertyDetails(widget.id);
                    }
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                        children: [
                          Text(
                            strings.adminReviewDetails,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 12.h),
                          if (widget.kind == _AdminQueueKind.identity &&
                              identityDetails != null) ...[
                            if (identityDetails.fullName.isNotEmpty)
                              _DetailValue(
                                label: strings.fullName,
                                value: identityDetails.fullName,
                              ),
                            if (identityDetails.email != null)
                              _DetailValue(
                                label: strings.email,
                                value: identityDetails.email!,
                              ),
                            if (identityDetails.status != null)
                              _DetailValue(
                                label: strings.identityVerification,
                                value: identityDetails.status!,
                              ),
                            if (identityDetails.submittedAt != null)
                              _DetailValue(
                                label: strings.adminSubmittedAt,
                                value: _formatDate(
                                  identityDetails.submittedAt!
                                      .toIso8601String(),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
                              child: AdminIdentityDocumentsSection(
                                documents: identityDetails.documents,
                                loadImage: context
                                    .read<AdminCubit>()
                                    .loadIdentityDocumentImage,
                              ),
                            ),
                          ] else if (detail != null) ...[
                            ..._imageEntries(detail).map(
                              (entry) => Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: _DetailImage(
                                  label: _fieldLabel(context, entry.$1),
                                  path: entry.$2,
                                ),
                              ),
                            ),
                            ..._flatten(detail)
                                .where((entry) {
                                  final key = entry.$1.toLowerCase();
                                  return !_isImageField(key) &&
                                      entry.$2.isNotEmpty;
                                })
                                .map(
                                  (entry) => Card(
                                    child: ListTile(
                                      title: Text(
                                        _fieldLabel(context, entry.$1),
                                      ),
                                      subtitle: SelectableText(entry.$2),
                                    ),
                                  ),
                                ),
                          ],
                        ],
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: state.processing
                                    ? null
                                    : () => _review(false),
                                icon: const Icon(Icons.close_rounded),
                                label: Text(strings.adminReject),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: state.processing
                                    ? null
                                    : () => _review(true),
                                icon: state.processing
                                    ? SizedBox.square(
                                        dimension: 16.sp,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.check_rounded),
                                label: Text(strings.adminApprove),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.darkGlow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _DetailImage extends StatelessWidget {
  const _DetailImage({required this.label, required this.path});

  final String label;
  final String path;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 6.h),
        child: Text(label, style: Theme.of(context).textTheme.titleSmall),
      ),
      GestureDetector(
        onTap: () => showDialog<void>(
          context: context,
          builder: (context) => Dialog.fullscreen(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    child: Image.network(
                      _imageUrl(path),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.broken_image_outlined, size: 64),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 16,
                  end: 16,
                  child: IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    tooltip: S.of(context).back,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            _imageUrl(path),
            width: double.infinity,
            height: 230.h,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 150.h,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
      ),
    ],
  );
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(title: Text(label), subtitle: SelectableText(value)),
  );
}

class _RecordImage extends StatelessWidget {
  const _RecordImage({required this.path, required this.size});

  final String? path;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: SizedBox.square(
        dimension: size,
        child: path == null
            ? ColoredBox(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.apartment_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : Image.network(
                _imageUrl(path!),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
      ),
    );
  }
}

class _AdminErrorView extends StatelessWidget {
  const _AdminErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 42.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 12.h),
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

String _errorMessage(BuildContext context, Object? error, String fallback) =>
    error == AppErrorType.unauthorized || error == AppErrorType.forbidden
    ? S.of(context).adminUnauthorized
    : fallback;

String? _recordId(Map<String, dynamic> record, _AdminQueueKind kind) {
  final value = kind == _AdminQueueKind.identity
      ? record['userId']
      : record['id'];
  return value is String && value.trim().isNotEmpty ? value.trim() : null;
}

String? _firstString(Map<String, dynamic> record, List<String> keys) {
  for (final key in keys) {
    final value = record[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return null;
}

List<(String, String)> _imageEntries(Map<String, dynamic> record) =>
    _flatten(record)
        .where(
          (entry) =>
              _isImageField(entry.$1.toLowerCase()) &&
              entry.$2.trim().isNotEmpty,
        )
        .toList(growable: false);

List<(String, String)> _flatten(Map<String, dynamic> record) {
  final entries = <(String, String)>[];
  void visit(String prefix, Object? value) {
    if (value is Map) {
      for (final entry in value.entries) {
        visit(
          prefix.isEmpty ? entry.key.toString() : '$prefix.${entry.key}',
          entry.value,
        );
      }
    } else if (value is List) {
      for (var index = 0; index < value.length; index++) {
        visit('$prefix ${index + 1}', value[index]);
      }
    } else if (value != null) {
      entries.add((prefix, value.toString()));
    }
  }

  for (final entry in record.entries) {
    visit(entry.key, entry.value);
  }
  return entries;
}

bool _isImageField(String key) =>
    key.contains('image') ||
    key.contains('photo') ||
    key.contains('selfie') ||
    key.contains('front') ||
    key.contains('back') ||
    key.contains('document');

String _imageUrl(String path) => resolveAdminDocumentUrl(path) ?? '';

String _formatDate(Object value) {
  final date = DateTime.tryParse(value.toString());
  return date == null
      ? value.toString()
      : intl.DateFormat.yMMMd().format(date.toLocal());
}

String _fieldLabel(BuildContext context, String key) {
  final normalized = key.split('.').last.replaceAll(RegExp(r'\s\d+$'), '');
  switch (normalized.toLowerCase()) {
    case 'title':
      return S.of(context).propertyTitleLabel;
    case 'description':
      return S.of(context).propertyDescriptionLabel;
    case 'city':
      return S.of(context).cityLabel;
    case 'nightlyprice':
      return S.of(context).nightlyPriceLabel;
    case 'beds':
      return S.of(context).bedsLabel;
    case 'rooms':
      return S.of(context).roomsLabel;
    case 'guests':
      return S.of(context).guestsLabel;
    case 'bathrooms':
      return S.of(context).bathroomsLabel;
    case 'email':
      return S.of(context).email;
    case 'firstname':
    case 'lastname':
      return S.of(context).fullName;
    case 'identityverificationstatus':
    case 'status':
      return S.of(context).identityVerification;
    case 'createdat':
      return S.of(context).adminReference;
    default:
      return normalized
          .replaceAllMapped(
            RegExp(r'([a-z])([A-Z])'),
            (match) => '${match[1]} ${match[2]}',
          )
          .replaceAll('_', ' ');
  }
}
