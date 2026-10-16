import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/home/widgets/search_text_field.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color _homeBrand = AppColors.darkGlow;

const _sampleProperties = <_Property>[
  _Property(
    title: _PropertyTitle.familyApartment,
    price: 436,
    location: _PropertyLocation.giza,
    imageUrl: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=85',
  ),
  _Property(
    title: _PropertyTitle.modernApartment,
    price: 550,
    location: _PropertyLocation.newCairo,
    imageUrl: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=85',
  ),
  _Property(
    title: _PropertyTitle.furnishedApartment,
    price: 380,
    location: _PropertyLocation.nasrCity,
    imageUrl: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=85',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  final Set<_PropertyTitle> _favoriteTitles = {};

  List<_Property> get _visibleProperties {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _sampleProperties;

    final localization = S.of(context);
    return _sampleProperties.where((property) {
      final title = property.title.localized(localization);
      final location = property.location.localized(localization);
      return title.toLowerCase().contains(query) ||
          location.toLowerCase().contains(query);
    }).toList();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
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
                  onChanged: (value) => setState(() => _searchQuery = value),
                  hintText: _searchHint,
                  filterTooltip: S.of(context).filters,
                  onFilterPressed: () => _showComingSoon(S.of(context).filters),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: _visibleProperties.isEmpty
                    ? Center(
                        child: Text(
                          _emptyStateText,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            fontSize: 15.sp,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 120.h),
                        itemCount: _visibleProperties.length,
                        separatorBuilder: (_, _) => SizedBox(height: 18.h),
                        itemBuilder: (context, index) {
                          final property = _visibleProperties[index];
                          final isFavorite = _favoriteTitles.contains(
                            property.title,
                          );

                          return _PropertyCard(
                            property: property,
                            isFavorite: isFavorite,
                            onFavoritePressed: () {
                              setState(() {
                                if (isFavorite) {
                                  _favoriteTitles.remove(property.title);
                                } else {
                                  _favoriteTitles.add(property.title);
                                }
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
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
                    'القاهرة، مصر',
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
    required this.onFavoritePressed,
  });

  final _Property property;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 320.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              property.imageUrl,
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
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border,
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
    );
  }
}

class _PropertyDetails extends StatelessWidget {
  const _PropertyDetails({required this.property});

  final _Property property;

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
                  property.title.localized(S.of(context)),
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
                        property.location.localized(S.of(context)),
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
                '\$${property.price}',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: _homeBrand,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                S.of(context).monthly,
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

class _Property {
  const _Property({
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
  });

  final _PropertyTitle title;
  final int price;
  final _PropertyLocation location;
  final String imageUrl;
}

enum _PropertyTitle {
  familyApartment,
  modernApartment,
  furnishedApartment;

  String localized(S localization) => switch (this) {
    _PropertyTitle.familyApartment => localization.propertyFamilyApartment,
    _PropertyTitle.modernApartment => localization.propertyModernApartment,
    _PropertyTitle.furnishedApartment =>
      localization.propertyFurnishedApartment,
  };
}

enum _PropertyLocation {
  giza,
  newCairo,
  nasrCity;

  String localized(S localization) => switch (this) {
    _PropertyLocation.giza => localization.propertyLocationGiza,
    _PropertyLocation.newCairo => localization.propertyLocationNewCairo,
    _PropertyLocation.nasrCity => localization.propertyLocationNasrCity,
  };
}
