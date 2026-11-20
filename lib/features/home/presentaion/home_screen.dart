import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/home/data/models/search_properties_filters.dart';
import 'package:egypto/features/home/data/models/search_properties_page.dart';
import 'package:egypto/features/home/presentation/cubit/home_properties_cubit.dart';
import 'package:egypto/features/home/widgets/property_filter_sheet.dart';
import 'package:egypto/features/home/widgets/search_text_field.dart';
import 'package:egypto/features/bookings/presentation/screens/property_details_screen.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

const Color _homeBrand = AppColors.darkGlow;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.profile, this.onProfileChanged});

  final UserProfileModel? profile;
  final ValueChanged<UserProfileModel>? onProfileChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final HomePropertiesCubit _propertiesCubit;
  String _searchQuery = '';
  final Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _propertiesCubit = getIt<HomePropertiesCubit>()..load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _propertiesCubit.close();
    super.dispose();
  }

  List<SearchProperty> _visibleProperties(Iterable<SearchProperty> items) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return items.toList(growable: false);
    return items
        .where(
          (property) =>
              property.title.toLowerCase().contains(query) ||
              (property.city?.toLowerCase().contains(query) ?? false),
        )
        .toList(growable: false);
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature ${S.of(context).comingSoon}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String get _searchHint => S.of(context).search;
  String get _emptyStateText => S.of(context).noPropertiesFound;

  Future<void> _showFilters(
    BuildContext context,
    List<String> availableCities,
  ) async {
    final cubit = context.read<HomePropertiesCubit>();
    final filters = await showModalBottomSheet<SearchPropertiesFilters>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => PropertyFilterSheet(
        initialFilters: cubit.currentFilters,
        availableCities: availableCities,
      ),
    );
    if (!mounted || filters == null) return;
    await cubit.search(filters);
  }

  void _clearSearchAndFilters(BuildContext context) {
    _searchController.clear();
    setState(() => _searchQuery = '');
    context.read<HomePropertiesCubit>().search(const SearchPropertiesFilters());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _propertiesCubit,
      child: BlocBuilder<HomePropertiesCubit, HomePropertiesState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          return Directionality(
            textDirection: Directionality.of(context),
            child: Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
                      child: _LocationHeader(
                        onMapTap: () => _showComingSoon(S.of(context).map),
                        onNotificationsTap: () =>
                            _showComingSoon(S.of(context).notifications),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                      child: SearchTextField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        hintText: _searchHint,
                        filterTooltip: S.of(context).filters,
                        onFilterPressed: () {
                          final cities = state is HomePropertiesLoaded
                              ? state.page.items
                                    .map((property) => property.city?.trim())
                                    .whereType<String>()
                                    .where((city) => city.isNotEmpty)
                                    .toSet()
                                    .toList()
                              : <String>[];
                          _showFilters(context, cities);
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: switch (state) {
                        HomePropertiesLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        HomePropertiesFailure() => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                S.of(context).propertiesLoadError,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),
                              FilledButton.icon(
                                onPressed: () =>
                                    context.read<HomePropertiesCubit>().load(),
                                icon: const Icon(Icons.refresh_rounded),
                                label: Text(S.of(context).retry),
                              ),
                            ],
                          ),
                        ),
                        HomePropertiesLoaded(:final page) => _buildPropertyList(
                          context,
                          _visibleProperties(page.items),
                        ),
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyList(
    BuildContext context,
    List<SearchProperty> properties,
  ) {
    if (properties.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _emptyStateText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 12.h),
              OutlinedButton.icon(
                onPressed: () => _clearSearchAndFilters(context),
                icon: const Icon(Icons.restart_alt_rounded),
                label: Text(S.of(context).clearFilters),
              ),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<HomePropertiesCubit>().load(),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 120.h),
        itemCount: properties.length,
        separatorBuilder: (_, _) => SizedBox(height: 18.h),
        itemBuilder: (context, index) {
          final property = properties[index];
          final isFavorite = _favoriteIds.contains(property.id);
          return _PropertyCard(
            property: property,
            isFavorite: isFavorite,
            onTap: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => PropertyDetailsScreen(
                  property: property,
                  profile: widget.profile,
                  onProfileChanged: (profile) {
                    widget.onProfileChanged?.call(profile);
                  },
                ),
              ),
            ),
            onFavoritePressed: () {
              setState(() {
                if (isFavorite) {
                  _favoriteIds.remove(property.id);
                } else {
                  _favoriteIds.add(property.id);
                }
              });
            },
          );
        },
      ),
    );
  }
}

class _LocationHeader extends StatelessWidget {
  const _LocationHeader({
    required this.onMapTap,
    required this.onNotificationsTap,
  });

  final VoidCallback onMapTap;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).location,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: AppColors.darkGlow,
                    size: 21.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    S.of(context).homeLocation,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
        _HeaderAction(
          icon: Icons.map_outlined,
          label: S.of(context).map,
          onPressed: onMapTap,
        ),
        SizedBox(width: 10.w),
        _HeaderAction(
          icon: Icons.notifications_none_rounded,
          label: S.of(context).notifications,
          onPressed: onNotificationsTap,
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: theme.colorScheme.surface,
        shape: const CircleBorder(),
        elevation: 1,
        shadowColor: theme.shadowColor.withValues(alpha: 0.08),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 44.w,
            height: 44.w,
            child: Icon(icon, color: theme.colorScheme.onSurface, size: 21.sp),
          ),
        ),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.property,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoritePressed,
  });

  final SearchProperty property;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = _resolveHomeImage(property.coverImageUrl);
    return SizedBox(
      height: 320.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Material(
          color: theme.colorScheme.surface,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                imageUrl == null
                    ? Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.apartment_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 52.sp,
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 28.w,
                              height: 28.w,
                              child: CircularProgressIndicator(
                                color: _homeBrand,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.apartment_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 52.sp,
                          ),
                        ),
                      ),
                Positioned(
                  left: 14.w,
                  top: 14.h,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: isFavorite
                          ? S.of(context).removeFromFavorites
                          : S.of(context).addToFavorites,
                      onPressed: onFavoritePressed,
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border,
                        color: Colors.white,
                        size: 21.sp,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12.w,
                  right: 12.w,
                  bottom: 12.h,
                  child: _PropertyDetails(property: property),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PropertyDetails extends StatelessWidget {
  const _PropertyDetails({required this.property});

  final SearchProperty property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
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
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: _homeBrand,
                      size: 15.sp,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        property.city ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${S.of(context).egp} ${intl.NumberFormat('#,##0.##', Localizations.localeOf(context).toLanguageTag()).format(property.nightlyPrice)}',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: _homeBrand,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                S.of(context).night,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String? _resolveHomeImage(String? path) {
  final value = path?.trim();
  if (value == null || value.isEmpty) return null;
  final uri = Uri.tryParse(value);
  if (uri != null && uri.hasScheme) return value;
  return Uri.parse(ApiConstants.baseUrl).resolve(value).toString();
}
