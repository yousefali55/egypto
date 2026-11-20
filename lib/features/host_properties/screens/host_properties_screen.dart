import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/host_properties/data/models/host_properties_page.dart';
import 'package:egypto/features/host_properties/presentation/cubit/host_properties_cubit.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HostPropertiesScreen extends StatelessWidget {
  const HostPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<HostPropertiesCubit>()..loadFirstPage(),
    child: const _HostPropertiesView(),
  );
}

class _HostPropertiesView extends StatelessWidget {
  const _HostPropertiesView();

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.hostPropertiesTitle)),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<HostPropertiesCubit, HostPropertiesState>(
          builder: (context, state) => switch (state) {
            HostPropertiesInitial() || HostPropertiesLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            HostPropertiesFailure() => _LoadError(
              message: strings.propertiesLoadError,
              onRetry: () =>
                  context.read<HostPropertiesCubit>().loadFirstPage(),
            ),
            HostPropertiesLoaded(
              :final page,
              :final isLoadingMore,
              :final loadMoreError,
            ) =>
              page.items.isEmpty
                  ? Center(child: Text(strings.noHostProperties))
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<HostPropertiesCubit>().loadFirstPage(),
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                        itemCount:
                            page.items.length + (page.hasNextPage ? 1 : 0),
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          if (index < page.items.length) {
                            return _HostPropertyTile(
                              property: page.items[index],
                            );
                          }
                          if (isLoadingMore) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (loadMoreError != null) {
                            return _LoadError(
                              message: strings.propertiesLoadError,
                              onRetry: () => context
                                  .read<HostPropertiesCubit>()
                                  .loadNextPage(),
                            );
                          }
                          return Center(
                            child: TextButton.icon(
                              onPressed: () => context
                                  .read<HostPropertiesCubit>()
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

class _HostPropertyTile extends StatelessWidget {
  const _HostPropertyTile({required this.property});

  final HostProperty property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = _resolveImageUrl(property.coverImageUrl);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 112.w,
            height: 120.h,
            child: imageUrl == null
                ? _ImagePlaceholder(icon: Icons.home_work_outlined)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        _ImagePlaceholder(icon: Icons.broken_image_outlined),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.w, 10.h, 12.w, 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (property.city?.isNotEmpty == true) ...[
                    SizedBox(height: 4.h),
                    Text(
                      property.city!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                  SizedBox(height: 7.h),
                  Text(
                    '${NumberFormat('#,##0.##', Localizations.localeOf(context).toLanguageTag()).format(property.nightlyPrice)} ${S.of(context).egp} / ${S.of(context).night}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.darkGlow.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      child: Text(
                        property.status.isEmpty
                            ? S.of(context).unknownStatus
                            : property.status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.darkGlow,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
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
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Center(
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 30.sp,
      ),
    ),
  );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(24.w),
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

String? _resolveImageUrl(String? path) {
  final value = path?.trim();
  if (value == null || value.isEmpty) return null;
  final uri = Uri.tryParse(value);
  if (uri != null && uri.hasScheme) return value;
  return Uri.parse(ApiConstants.baseUrl).resolve(value).toString();
}
