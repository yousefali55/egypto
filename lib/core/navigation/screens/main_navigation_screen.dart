import 'package:egypto/core/navigation/cubit/floating_bottom_nav_bar_cubit.dart';
import 'package:egypto/core/navigation/floating_bottom_nav_bar.dart';
import 'package:egypto/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:egypto/features/explore/screens/explore_screen.dart';
import 'package:egypto/features/home/presentaion/home_screen.dart';
import 'package:egypto/features/messages/screens/messages_screen.dart';
import 'package:egypto/features/my_account/screens/my_account_screen.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/host_properties/screens/add_property_screen.dart';
import 'package:egypto/features/host_properties/screens/host_properties_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  UserProfileModel? _profile;
  bool _roleResolved = false;

  void _onProfileChanged(UserProfileModel? profile) {
    if (!mounted) return;
    final changed =
        !_roleResolved ||
        _profile?.id != profile?.id ||
        _profile?.isHost != profile?.isHost ||
        _profile?.isAdmin != profile?.isAdmin ||
        _profile?.identityVerificationStatus !=
            profile?.identityVerificationStatus;
    if (!changed) return;
    setState(() {
      _profile = profile;
      _roleResolved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FloatingBottomNavBarCubit(),
      child: BlocBuilder<FloatingBottomNavBarCubit, int>(
        builder: (context, currentIndex) {
          if (_profile?.isAdmin == true) {
            return AdminHomeScreen(
              profile: _profile!,
              onProfileChanged: _onProfileChanged,
            );
          }
          final isHost = _profile?.isHost == true;
          final screens = <Widget>[
            HomeScreen(profile: _profile, onProfileChanged: _onProfileChanged),
            const MessagesScreen(),
            const ExploreScreen(),
            MyAccountScreen(
              isActive: currentIndex == 3 || !_roleResolved,
              onProfileChanged: _onProfileChanged,
            ),
            if (isHost)
              AddPropertyScreen(
                profile: _profile!,
                onSubmitted: () {
                  context.read<FloatingBottomNavBarCubit>().changeindex(3);
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const HostPropertiesScreen(),
                    ),
                  );
                },
              ),
          ];

          final safeIndex = currentIndex < screens.length ? currentIndex : 3;

          return Scaffold(
            body: Stack(
              children: [
                IndexedStack(index: safeIndex, children: screens),
                if (!_roleResolved)
                  Positioned.fill(
                    child: ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (_roleResolved)
                  Positioned(
                    left: 20.w,
                    right: 20.w,
                    bottom: MediaQuery.paddingOf(context).bottom + 16.h,
                    child: FloatingBottomNavBar(
                      currentIndex: safeIndex,
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
                        if (isHost)
                          FloatingBottomNavItem(
                            icon: const Icon(Icons.add_home_rounded),
                            label: S.of(context).addPropertyTitle,
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
