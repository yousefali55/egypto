import 'package:egypto/core/navigation/cubit/floating_bottom_nav_bar_cubit.dart';
import 'package:egypto/core/navigation/floating_bottom_nav_bar.dart';
import 'package:egypto/features/explore/screens/explore_screen.dart';
import 'package:egypto/features/home/presentaion/home_screen.dart';
import 'package:egypto/features/messages/screens/messages_screen.dart';
import 'package:egypto/features/my_account/screens/my_account_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FloatingBottomNavBarCubit(),
      child: BlocBuilder<FloatingBottomNavBarCubit, int>(
        builder: (context, currentIndex) {
          final screens = [
            const HomeScreen(),
            const MessagesScreen(),
            const ExploreScreen(),
            MyAccountScreen(isActive: currentIndex == 3),
          ];

          return Scaffold(
            body: Stack(
              children: [
                IndexedStack(index: currentIndex, children: screens),

                Positioned(
                  left: 20.w,
                  right: 20.w,
                  bottom: MediaQuery.paddingOf(context).bottom + 16.h,
                  child: FloatingBottomNavBar(
                    currentIndex: currentIndex,
                    onItemSelected: (index) {
                      context.read<FloatingBottomNavBarCubit>().changeindex(
                        index,
                      );
                    },
                    items: [
                      FloatingBottomNavItem(
                        icon: SvgPicture.asset('assets/svgs/house.svg'),
                        label: S.of(context).home,
                      ),

                      FloatingBottomNavItem(
                        icon: SvgPicture.asset('assets/svgs/messages.svg'),
                        label: S.of(context).messages,
                      ),

                      FloatingBottomNavItem(
                        icon: SvgPicture.asset('assets/svgs/explore.svg'),
                        label: S.of(context).explore,
                      ),

                      FloatingBottomNavItem(
                        icon: SvgPicture.asset('assets/svgs/home.svg'),
                        label: S.of(context).MyAccount,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
