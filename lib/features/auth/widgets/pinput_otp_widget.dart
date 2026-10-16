import 'package:egypto/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class PinputOtpWidget extends StatelessWidget {
  final TextEditingController controller;
  const PinputOtpWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: controller,
      keyboardType: TextInputType.number,
      defaultPinTheme: PinTheme(
        width: 56.w,
        height: 56.h,
        textStyle: GoogleFonts.cairo(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 56.w,
        height: 56.h,
        textStyle: GoogleFonts.cairo(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: AppColors.darkGreen),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      errorPinTheme: PinTheme(
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      ),
      // animationDuration: Duration(),
      autofocus: true,
      length: 6,
    );
  }
}
