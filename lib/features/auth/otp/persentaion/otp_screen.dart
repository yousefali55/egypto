import 'dart:async';

import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/auth/otp/persentaion/cubit/otp_cubit.dart';
import 'package:egypto/features/auth/widgets/login_or_register_button.dart';
import 'package:egypto/features/auth/widgets/main_text.dart';
import 'package:egypto/features/auth/widgets/pinput_otp_widget.dart';
import 'package:egypto/features/auth/widgets/sub_main_text.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPEnterScreen extends StatefulWidget {
  const OTPEnterScreen({super.key, required this.email});

  final String email;

  @override
  State<OTPEnterScreen> createState() => _OTPEnterScreenState();
}

class _OTPEnterScreenState extends State<OTPEnterScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _countdownRestartKey = 0;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpVerified) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.green,
                  content: Text(S.of(context).otpVerificationSuccess),
                ),
              );
              Navigator.of(context).pop(true);
            } else if (state is OtpResent) {
              _otpController.clear();
              setState(() => _countdownRestartKey++);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.green,
                  content: Text(S.of(context).otpResendSuccess),
                ),
              );
            } else if (state is OtpVerificationFailure) {
              _showError(context, state.exception);
            } else if (state is OtpResendFailure) {
              _showError(context, state.exception);
            }
          },
          builder: (context, state) {
            final isVerifying = state is OtpVerifying;
            final isResending = state is OtpResending;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h),
                  MainText(text: S.of(context).enterVerficationCode),
                  SizedBox(height: 10.h),
                  SubMainText(text: S.of(context).checkOtp),
                  SizedBox(height: 30.h),
                  Center(child: PinputOtpWidget(controller: _otpController)),
                  SizedBox(height: 18.h),
                  OtpCountdown(
                    key: ValueKey(_countdownRestartKey),
                    isResending: isResending,
                    onResend: context.read<OtpCubit>().resend,
                  ),
                  SizedBox(height: 30.h),
                  isVerifying
                      ? SizedBox(
                          height: 60.h,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      : LoginOrRegisterButton(
                          buttonText: S.of(context).verify,
                          onPressed: () {
                            if (!RegExp(r'^[0-9]{6}$')
                                .hasMatch(_otpController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.red,
                                  content: Text(S.of(context).otpCodeRequired),
                                ),
                              );
                              return;
                            }
                            context.read<OtpCubit>().verify(
                              _otpController.text,
                            );
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showError(BuildContext context, AppException exception) {
    final strings = S.of(context);
    final message = switch (exception.errorType) {
      AppErrorType.network || AppErrorType.timeout => strings.otpNetworkError,
      AppErrorType.validation ||
      AppErrorType.unauthorized ||
      AppErrorType.forbidden => strings.otpInvalidOrExpired,
      AppErrorType.server => strings.otpServerError,
      _ => strings.otpGenericError,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: AppColors.red, content: Text(message)),
    );
  }
}

class OtpCountdown extends StatefulWidget {
  const OtpCountdown({
    super.key,
    required this.isResending,
    required this.onResend,
    this.duration = const Duration(minutes: 5),
  });

  final bool isResending;
  final VoidCallback onResend;
  final Duration duration;

  @override
  State<OtpCountdown> createState() => _OtpCountdownState();
}

class _OtpCountdownState extends State<OtpCountdown> {
  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant OtpCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _remainingSeconds = widget.duration.inSeconds;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (_remainingSeconds <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    final expired = _remainingSeconds == 0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: expired
          ? widget.isResending
                ? SizedBox(
                    key: const ValueKey('resending'),
                    height: 48.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          S.of(context).otpResending,
                          style: GoogleFonts.cairo(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : TextButton.icon(
                    key: const ValueKey('resend'),
                    onPressed: widget.onResend,
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      S.of(context).resendCode,
                      style: GoogleFonts.cairo(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
          : Row(
              key: const ValueKey('countdown'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 18.sp,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 6.w),
                Text(
                  S.of(context).otpResendAvailableIn,
                  style: GoogleFonts.cairo(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 7.w),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Text(
                    '$minutes:$seconds',
                    key: ValueKey(_remainingSeconds),
                    style: GoogleFonts.cairo(
                      color: theme.colorScheme.primary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
