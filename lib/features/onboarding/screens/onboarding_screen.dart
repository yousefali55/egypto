import 'package:egypto/core/theming/app_theme.dart';
import 'package:egypto/features/onboarding/Model/onboarding_model.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<OnBoardingModel> onBoardingData = [
      OnBoardingModel(
        image: 'assets/images/onBoarding1.png',
        title: S.of(context).onBoardingTitle,
        description: S.of(context).onBoardingDescription,
      ),
      OnBoardingModel(
        image: 'assets/images/onBoarding2.png',
        title: S.of(context).onBoardingTitle2,
        description: S.of(context).onBoardingDescription2,
      ),
      OnBoardingModel(
        image: 'assets/images/onBoarding3.png',
        title: S.of(context).onBoardingTitle3,
        description: S.of(context).onBoardingDescription3,
      ),
    ];
    return AppBackground(
      child: Column(
        children: [
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: PageView.builder(
                itemCount: onBoardingData.length,
                itemBuilder: (context, itemCount) {
                  final data = onBoardingData[itemCount];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 450.h,
                        width: 400.w,
                        child: Image.asset(data.image)),
                      SizedBox(height: 20.h),
                      Text(
                        data.title,
                        style: GoogleFonts.cairo(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        )
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
