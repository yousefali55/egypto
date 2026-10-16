import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/features/auth/register/persentation/cubit/register_cubit.dart';
import 'package:egypto/features/auth/register/persentation/widgets/role_drop_down.dart';
import 'package:egypto/features/auth/widgets/custom_text_field.dart';
import 'package:egypto/features/auth/widgets/login_or_register_button.dart';
import 'package:egypto/features/auth/widgets/login_or_register_text.dart';
import 'package:egypto/features/auth/widgets/main_text.dart';
import 'package:egypto/features/auth/widgets/sub_main_text.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.green,
                  content: Text(state.response.message),
                ),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.red,
                  content: Text(state.exception.message),
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Image.asset(
                    "assets/images/register_image.png",
                    width: 300.w,
                    height: 300.h,
                  ),
                  SizedBox(height: 10.h),
                  MainText(text: S.of(context).register),
                  SizedBox(height: 5.h),
                  SubMainText(text: S.of(context).enterData),
                  SizedBox(height: 15.h),
                  CustomTextField(
                    controller: context
                        .read<RegisterCubit>()
                        .firstNameController,
                    hintText: S.of(context).firstName,
                    obscureText: false,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: context
                        .read<RegisterCubit>()
                        .lastNameController,
                    hintText: S.of(context).lastName,
                    obscureText: false,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: context.read<RegisterCubit>().emailController,
                    hintText: S.of(context).email,
                    obscureText: false,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: context
                        .read<RegisterCubit>()
                        .passwordController,
                    hintText: S.of(context).password,
                    obscureText: true,
                  ),
                  SizedBox(height: 10.h),
                  RoleDropdown(
                    onChanged: (role) {
                      context.read<RegisterCubit>().selectedRole = role;
                    },
                  ),
                  // CustomTextField(
                  //   hintText: S.of(context).confirmPassword,
                  //   obscureText: true,
                  // ),
                  SizedBox(height: 30.h),
                  LoginOrRegisterText(
                    loginORRegisterText: S.of(context).alreadyHaveAccount,
                    actionText: S.of(context).login,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 20.h),
                  state is RegisterLoading
                      ? CircularProgressIndicator()
                      : LoginOrRegisterButton(
                          buttonText: S.of(context).register,
                          onPressed: () {
                            context.read<RegisterCubit>().register();
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
}
