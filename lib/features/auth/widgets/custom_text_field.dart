import 'package:egypto/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.obscureText,
  });

  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        cursorColor: Theme.of(context).colorScheme.primary,
        cursorHeight: 25.h,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.cairo(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.primary),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 16.0,
          ),
        ),
      ),
    );
  }
}
