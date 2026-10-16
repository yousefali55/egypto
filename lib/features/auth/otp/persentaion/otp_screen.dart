import 'package:egypto/features/auth/widgets/login_or_register_button.dart';
import 'package:egypto/features/auth/widgets/main_text.dart';
import 'package:egypto/features/auth/widgets/pinput_otp_widget.dart';
import 'package:egypto/features/auth/widgets/sub_main_text.dart';
import 'package:egypto/features/home/presentaion/home_screen.dart';
import 'package:egypto/features/location/data/cubit/loction_cubit.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:egypto/utils/prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPEnterScreen extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();
  OTPEnterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),
              MainText(text: S.of(context).enterVerficationCode),
              SizedBox(height: 10.h),
              SubMainText(text: S.of(context).checkOtp),
              SizedBox(height: 30.h),
              Center(child: PinputOtpWidget(controller: _otpController)),
              SizedBox(height: 30.h),
              LoginOrRegisterButton(
                buttonText: S.of(context).verify,
                onPressed: () async {
                  final otp = _otpController.text;
                  if (otp == '482002') {
                    await PrefsHelper.setBoolOtp(true);

                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => LocationCubit()..getLocation(),
                          child: HomeScreen(),
                        ),
                      ),
                    );
                  }
                  print(" OTP entered: $otp");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
