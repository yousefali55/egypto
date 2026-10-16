import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/auth/login/persentation/cubit/login_cubit.dart';
import 'package:egypto/features/auth/register/persentation/cubit/register_cubit.dart';
import 'package:egypto/features/auth/register/persentation/register_screen.dart';
import 'package:egypto/features/auth/widgets/custom_text_field.dart';
import 'package:egypto/features/auth/widgets/login_or_register_button.dart';
import 'package:egypto/features/auth/widgets/login_or_register_text.dart';
import 'package:egypto/features/auth/widgets/main_text.dart';
import 'package:egypto/features/auth/widgets/sub_main_text.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.green,
                    content: Text(S.of(context).loginSuccessfull),
                  ),
                );
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(true);
                }
              }
              if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.red,
                    content: Text(state.exception.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();
              final isLoading = state is LoginLoading;
              return Column(
                children: [
                  SizedBox(height: 50.h),
                  Image.asset(
                    "assets/images/login_image.png",
                    width: 300.w,
                    height: 300.h,
                  ),
                  SizedBox(height: 20.h),
                  MainText(text: S.of(context).login),
                  SizedBox(height: 5.h),
                  SubMainText(text: S.of(context).enterData),
                  SizedBox(height: 50.h),
                  CustomTextField(
                    controller: cubit.emailController,
                    hintText: S.of(context).email,
                    obscureText: false,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    controller: cubit.passwordController,
                    hintText: S.of(context).password,
                    obscureText: true,
                  ),
                  SizedBox(height: 50.h),
                  LoginOrRegisterText(
                    loginORRegisterText: S.of(context).dontHaveAccount,
                    actionText: S.of(context).register,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => getIt<RegisterCubit>(),
                            child: const RegisterScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  // Spacer(),
                  SizedBox(height: 20.h),
                  isLoading
                      ? CircularProgressIndicator()
                      : LoginOrRegisterButton(
                          buttonText: S.of(context).login,
                          onPressed: cubit.login,
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
