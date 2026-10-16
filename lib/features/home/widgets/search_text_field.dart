import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.onChanged,
    required this.onFilterPressed,
    this.hintText,
    this.filterTooltip,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;
  final String? hintText;
  final String? filterTooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      textDirection: Directionality.of(context),
      textAlign: TextAlign.right,
      cursorColor: AppColors.darkGlow,
      style: TextStyle(fontSize: 15.sp, color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hintText ?? S.of(context).search,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.only(start: 15.w, end: 10.w),
          child: SvgPicture.asset(
            'assets/svgs/search.svg',
            width: 20.w,
            height: 20.w,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 48.h),
        suffixIcon: Padding(
          padding: EdgeInsetsDirectional.only(start: 6.w, end: 6.w),
          child: SizedBox(
            width: 48.w,
            height: 44.h,
            child: IconButton(
              tooltip: filterTooltip ?? S.of(context).filters,
              onPressed: onFilterPressed,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.darkGlow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.r),
                ),
              ),
              icon: SvgPicture.asset(
                'assets/svgs/filter.svg',
                width: 21.w,
                height: 21.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        suffixIconConstraints: BoxConstraints(minWidth: 58.w, minHeight: 54.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.darkGlow, width: 1.3),
        ),
      ),
    );
  }
}
