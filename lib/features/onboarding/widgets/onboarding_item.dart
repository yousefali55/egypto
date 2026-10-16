import 'package:egypto/features/onboarding/Model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingItem extends StatelessWidget {
  final OnBoardingModel data;
  const OnboardingItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 450.h, width: 400.w, child: Image.asset(data.image)),
        SizedBox(height: 20.h),
        Text(
          data.title,
          style: GoogleFonts.cairo(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            data.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
