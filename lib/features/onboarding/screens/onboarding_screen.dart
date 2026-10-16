import 'package:egypto/core/theming/app_background.dart';
import 'package:egypto/features/auth/login/persentation/login_screen.dart';
import 'package:egypto/features/onboarding/Model/onboarding_model.dart';
import 'package:egypto/features/onboarding/data/cubit/on_boarding_cubit.dart';
import 'package:egypto/features/onboarding/widgets/onboarding_item.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<OnBoardingModel> onBoardingData = [
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
                controller: context.read<OnBoardingCubit>().pageController,
                itemCount: onBoardingData.length,
                onPageChanged: (index) {
                  context.read<OnBoardingCubit>().changePage(index);
                },
                itemBuilder: (context, index) {
                  final data = onBoardingData[index];

                  return OnboardingItem(data: data);
                },
              ),
            ),
          ),

          BlocBuilder<OnBoardingCubit, OnBoardingState>(
            builder: (context, state) {
              final isLastPage =
                  state.currentIndex == onBoardingData.length - 1;

              final isArabic =
                  Localizations.localeOf(context).languageCode == 'ar';

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isLastPage
                        ? Center(
                            key: const ValueKey('getStarted'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 220.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(18.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor.withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(18.r),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          S.of(context).getStarted,
                                          style: GoogleFonts.cairo(
                                            color: Theme.of(context).colorScheme.onPrimary,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Icon(
                                          Icons.check,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Row(
                            key: const ValueKey('normalPage'),
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(30.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30.r),
                                    onTap: () {
                                      context.read<OnBoardingCubit>().nextPage(
                                        onBoardingData.length,
                                      );
                                    },
                                      child: Icon(
                                      isArabic
                                          ? Icons.arrow_back
                                          : Icons.arrow_forward,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(),

                              TextButton(
                                onPressed: () {
                                  // Skip
                                },
                                child: Text(
                                  S.of(context).skip,
                                  style: GoogleFonts.cairo(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
