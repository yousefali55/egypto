import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/auth/login/persentation/cubit/login_cubit.dart';
import 'package:egypto/features/auth/login/persentation/login_screen.dart';
import 'package:egypto/features/auth/register/persentation/cubit/register_cubit.dart';
import 'package:egypto/features/auth/register/persentation/register_screen.dart';
import 'package:egypto/features/auth/widgets/login_or_register_button.dart';
import 'package:egypto/features/my_account/data/models/user_profile_model.dart';
import 'package:egypto/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:egypto/features/my_account/presentation/phone_number/edit_phone_cubit.dart';
import 'package:egypto/features/my_account/screens/edit_phone_number_screen.dart';
import 'package:egypto/features/my_account/presentation/identity_verification/identity_verification_cubit.dart';
import 'package:egypto/features/my_account/screens/identity_verification_screen.dart';
import 'package:egypto/features/host_properties/screens/host_properties_screen.dart';
import 'package:egypto/features/bookings/presentation/screens/guest_bookings_screen.dart';
import 'package:egypto/features/bookings/presentation/screens/host_bookings_screen.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _accountBlue = AppColors.darkGlow;

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({
    super.key,
    this.isActive = true,
    this.onProfileChanged,
    this.adminMode = false,
  });

  final bool isActive;
  final ValueChanged<UserProfileModel?>? onProfileChanged;
  final bool adminMode;

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late final MyAccountCubit _cubit;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<MyAccountCubit>();
    _cubit.restoreSession();
    _loadProfile();
  }

  @override
  void didUpdateWidget(covariant MyAccountScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive && !_hasLoaded) {
      _loadProfile();
    }
  }

  void _loadProfile() {
    _hasLoaded = true;
    _cubit.loadProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<MyAccountCubit, MyAccountState>(
        listener: (context, state) {
          if (state is MyAccountLoaded) {
            widget.onProfileChanged?.call(state.profile);
          } else if (state is MyAccountUnauthenticated ||
              state is MyAccountFailure) {
            widget.onProfileChanged?.call(null);
          }
        },
        child: BlocBuilder<MyAccountCubit, MyAccountState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: switch (state) {
                  MyAccountUnauthenticated() => _GuestAccountView(
                    onLogin: () => _openLogin(context),
                    onRegister: () => _openRegister(context),
                  ),
                  MyAccountSessionRestored() ||
                  MyAccountLoading() => const _AccountLoadingView(),
                  MyAccountLoaded(:final profile) => _AuthenticatedAccountView(
                    profile: profile,
                    adminMode: widget.adminMode,
                    onLogout: _confirmLogout,
                    onEditPhone: () => _editPhoneNumber(profile.phone),
                    onIdentityVerification: () => _openIdentityVerification(
                      profile.identityVerificationStatus,
                    ),
                    onRefresh: _refreshProfile,
                    onHostProperties: _openHostProperties,
                    onBecomeHost: _confirmBecomeHost,
                  ),
                  MyAccountFailure(:final message) => _AccountErrorView(
                    message: message,
                    onRetry: _loadProfile,
                  ),
                  MyAccountInitial() => const _AccountLoadingView(),
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openLogin(BuildContext context) async {
    final loggedIn = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => getIt<LoginCubit>(),
          child: const LoginScreen(),
        ),
      ),
    );
    if (!mounted || !context.mounted) return;
    if (loggedIn == true) {
      await _cubit.loadProfile(forceSessionRestore: true);
    }
  }

  Future<void> _openRegister(BuildContext context) async {
    final emailVerified = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => getIt<RegisterCubit>(),
          child: const RegisterScreen(),
        ),
      ),
    );
    if (!mounted || !context.mounted) return;
    if (emailVerified == true) {
      await _openLogin(context);
    }
  }

  Future<void> _editPhoneNumber(String? currentPhone) async {
    final updatedPhone = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => BlocProvider(
          create: (_) => getIt<EditPhoneCubit>(),
          child: EditPhoneNumberScreen(currentPhone: currentPhone),
        ),
      ),
    );
    if (!mounted || updatedPhone == null) return;

    _cubit.applyPhoneNumber(updatedPhone);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.of(context).phoneUpdateSuccess)));
  }

  Future<void> _openIdentityVerification(String? currentStatus) async {
    final submitted = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => getIt<IdentityVerificationCubit>(),
          child: IdentityVerificationScreen(currentStatus: currentStatus),
        ),
      ),
    );
    if (!mounted || submitted != true) return;
    await _cubit.loadProfile();
  }

  Future<void> _refreshProfile() async {
    final refreshed = await _cubit.refreshProfile();
    if (!mounted || refreshed) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(S.of(context).profileRefreshError)),
      );
  }

  Future<void> _openHostProperties() => Navigator.of(context).push<void>(
    MaterialPageRoute<void>(builder: (_) => const HostPropertiesScreen()),
  );

  Future<void> _confirmBecomeHost() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(dialogContext).becomeHostTitle),
        content: Text(S.of(dialogContext).becomeHostConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(S.of(dialogContext).cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(S.of(dialogContext).becomeHost),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final activated = await _cubit.activateHost();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            activated
                ? S.of(context).hostActivationSuccess
                : S.of(context).hostActivationFailure,
          ),
        ),
      );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(dialogContext).logout),
        content: Text(S.of(dialogContext).logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(S.of(dialogContext).cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: _accountBlue),
            child: Text(S.of(dialogContext).logout),
          ),
        ],
      ),
    );
    if (shouldLogout != true || !mounted) return;

    try {
      await _cubit.logout();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.of(context).logoutFailed)));
    }
  }
}

class _GuestAccountView extends StatelessWidget {
  const _GuestAccountView({required this.onLogin, required this.onRegister});

  final VoidCallback onLogin;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 126.h),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              S.of(context).MyAccount,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 23.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
                  .withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Image.asset(
              'assets/images/register_image.png',
              height: 270.h,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            S.of(context).accountWaiting,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 25.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            S.of(context).accountWelcomeText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 15.sp,
              height: 1.7,
            ),
          ),
          SizedBox(height: 26.h),
          LoginOrRegisterButton(
            onPressed: onLogin,
            buttonText: S.of(context).login,
          ),
          // SizedBox(
          //   width: double.infinity,
          //   height: 54.h,
          //   child: FilledButton(
          //     onPressed: onLogin,
          //     style: FilledButton.styleFrom(
          //       backgroundColor: _accountBlue,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(16.r),
          //       ),
          //     ),
          //     child: Text(
          //       'تسجيل الدخول',
          //       style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          //     ),
          //   ),
          // ),
          SizedBox(height: 13.h),
          TextButton(
            onPressed: onRegister,
            child: Text(
              S.of(context).createAccount,
              style: TextStyle(
                color: AppColors.darkGlow,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthenticatedAccountView extends StatelessWidget {
  const _AuthenticatedAccountView({
    required this.profile,
    required this.adminMode,
    required this.onLogout,
    required this.onEditPhone,
    required this.onIdentityVerification,
    required this.onRefresh,
    required this.onHostProperties,
    required this.onBecomeHost,
  });

  final UserProfileModel profile;
  final bool adminMode;
  final VoidCallback onLogout;
  final VoidCallback onEditPhone;
  final VoidCallback onIdentityVerification;
  final Future<void> Function() onRefresh;
  final VoidCallback onHostProperties;
  final VoidCallback onBecomeHost;

  @override
  Widget build(BuildContext context) {
    final fullName = profile.fullName.isEmpty
        ? S.of(context).MyAccount
        : profile.fullName;
    final accountType = profile.isAdmin
        ? S.of(context).adminRole
        : profile.isHost
        ? S.of(context).host
        : S.of(context).guest;
    final identityStatus = _identityStatusLabel(
      profile.identityVerificationStatus,
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      semanticsLabel: S.of(context).refreshProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 126.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).MyAccount,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 23.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 22.h),
            Container(
              padding: EdgeInsets.all(18.r),
              decoration: _surfaceDecoration(context),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundColor: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.1),
                    child: Text(
                      _initials(fullName),
                      style: TextStyle(
                        color: _accountBlue,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (profile.identityVerificationStatus ==
                                'Verified')
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 5.w),
                                child: Icon(
                                  Icons.verified_rounded,
                                  color: _accountBlue,
                                  size: 18.sp,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          profile.email,
                          textDirection: TextDirection.ltr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            accountType,
                            style: TextStyle(
                              color: _accountBlue,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              S.of(context).personalInfo,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 11.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: _surfaceDecoration(context),
              child: Column(
                children: [
                  _AccountInfoTile(
                    icon: Icons.person_outline_rounded,
                    label: S.of(context).fullName,
                    value: fullName,
                  ),
                  _accountDivider(context),
                  _AccountInfoTile(
                    icon: Icons.mail_outline_rounded,
                    label: S.of(context).email,
                    value: profile.email,
                    valueDirection: TextDirection.ltr,
                  ),
                  _accountDivider(context),
                  _AccountInfoTile(
                    icon: Icons.phone_outlined,
                    label: S.of(context).phone,
                    value: profile.phone?.trim().isNotEmpty == true
                        ? profile.phone!.trim()
                        : S.of(context).addPhoneNumber,
                    valueDirection: TextDirection.ltr,
                    onTap: onEditPhone,
                    trailing: Icon(
                      Icons.edit_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 18.sp,
                    ),
                  ),
                  _accountDivider(context),
                  _AccountInfoTile(
                    icon: Icons.badge_outlined,
                    label: S.of(context).accountType,
                    value: accountType,
                  ),
                  _accountDivider(context),
                  _AccountInfoTile(
                    icon: Icons.verified_user_outlined,
                    label: S.of(context).identityVerification,
                    value: identityStatus,
                    onTap: onIdentityVerification,
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            if (!adminMode && profile.isHost) ...[
              _AccountActionTile(
                icon: Icons.event_note_outlined,
                label: S.of(context).hostBookingsTitle,
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => HostBookingsScreen(profile: profile),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              _AccountActionTile(
                icon: Icons.home_work_outlined,
                label: S.of(context).hostPropertiesTitle,
                onTap: onHostProperties,
              ),
              SizedBox(height: 12.h),
              _AccountActionTile(
                icon: Icons.bookmark_border_rounded,
                label: S.of(context).guestBookingsTitle,
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => GuestBookingsScreen(profile: profile),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ] else if (!adminMode) ...[
              _AccountActionTile(
                icon: Icons.home_work_outlined,
                label: S.of(context).becomeHost,
                onTap: onBecomeHost,
                isLoading: context.select<MyAccountCubit, bool>(
                  (cubit) =>
                      cubit.state is MyAccountLoaded &&
                      (cubit.state as MyAccountLoaded).isActivatingHost,
                ),
              ),
              SizedBox(height: 12.h),
            ],
            _AccountActionTile(
              icon: Icons.logout_rounded,
              label: S.of(context).logout,
              isDestructive: true,
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountErrorView extends StatelessWidget {
  const _AccountErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 52.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 16.h),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(S.of(context).retry),
              style: FilledButton.styleFrom(backgroundColor: _accountBlue),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountLoadingView extends StatelessWidget {
  const _AccountLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: _accountBlue),
          SizedBox(height: 14.h),
          Text(
            S.of(context).loadingAccount,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountInfoTile extends StatelessWidget {
  const _AccountInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueDirection = TextDirection.rtl,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextDirection valueDirection;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 13.h),
          child: Row(
            children: [
              Icon(icon, color: _accountBlue, size: 20.sp),
              SizedBox(width: 11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      value,
                      textDirection: valueDirection,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[SizedBox(width: 10.w), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountActionTile extends StatelessWidget {
  const _AccountActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFD64C4C) : _accountBlue;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              if (isLoading)
                SizedBox(
                  width: 21.sp,
                  height: 21.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              else
                Icon(icon, color: color, size: 21.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_left_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 21.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

BoxDecoration _surfaceDecoration(BuildContext context) => BoxDecoration(
  color: Theme.of(context).colorScheme.surface,
  borderRadius: BorderRadius.circular(18.r),
  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
);

Widget _accountDivider(BuildContext context) =>
    Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant);

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length > 1) return '${parts.first[0]}${parts.last[0]}';
  return parts.first.isEmpty ? 'ح' : parts.first[0];
}

String _identityStatusLabel(String? status) {
  return switch (status) {
    'NotSubmitted' => 'لم يتم تقديم طلب التحقق',
    'Pending' => 'قيد المراجعة',
    'Verified' => 'تم التحقق',
    'Rejected' => 'تم رفض التحقق',
    _ => 'غير محدد',
  };
}
