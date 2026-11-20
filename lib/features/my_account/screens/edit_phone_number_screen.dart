import 'package:egypto/core/theming/app_colors.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/features/my_account/presentation/phone_number/edit_phone_cubit.dart';
import 'package:egypto/features/my_account/presentation/phone_number/egyptian_phone_number.dart';
import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditPhoneNumberScreen extends StatefulWidget {
  const EditPhoneNumberScreen({super.key, this.currentPhone});

  final String? currentPhone;

  @override
  State<EditPhoneNumberScreen> createState() => _EditPhoneNumberScreenState();
}

class _EditPhoneNumberScreenState extends State<EditPhoneNumberScreen> {
  late final TextEditingController _phoneController;
  late final FocusNode _phoneFocusNode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: egyptianMobileInputValue(widget.currentPhone),
    );
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocListener<EditPhoneCubit, EditPhoneState>(
      listener: (context, state) {
        if (state is EditPhoneSuccess) {
          Navigator.of(context).pop(state.phone);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Text(S.of(context).editPhoneNumber)),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsetsDirectional.fromSTEB(24.w, 12.h, 24.w, 24.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 36.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 76.r,
                          height: 76.r,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.phone_iphone_rounded,
                            color: colors.primary,
                            size: 34.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 22.h),
                      Text(
                        S.of(context).editPhoneTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        S.of(context).editPhoneDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 14.sp,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Text(
                        S.of(context).phone,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 9.h),
                      Form(
                        key: _formKey,
                        child: BlocBuilder<EditPhoneCubit, EditPhoneState>(
                          builder: (context, state) {
                            final isLoading = state is EditPhoneLoading;
                            return TextFormField(
                              controller: _phoneController,
                              focusNode: _phoneFocusNode,
                              keyboardType: TextInputType.phone,
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.start,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enabled: !isLoading,
                              autofillHints: const [
                                AutofillHints.telephoneNumber,
                              ],
                              decoration: InputDecoration(
                                hintText: '010 1234 5678',
                                hintTextDirection: TextDirection.ltr,
                                prefixIcon: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    start: 12.w,
                                    end: 10.w,
                                  ),
                                  child: _EgyptCountryCode(),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0,
                                  minHeight: 0,
                                ),
                                suffixIcon: const Icon(Icons.phone_outlined),
                                filled: true,
                                fillColor: colors.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(
                                    color: colors.outlineVariant,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(
                                    color: colors.outlineVariant,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(
                                    color: colors.primary,
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(color: colors.error),
                                ),
                              ),
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return S.of(context).phoneRequired;
                                }
                                if (normalizeEgyptianMobileNumber(value!) ==
                                    null) {
                                  return S.of(context).invalidEgyptianMobile;
                                }
                                return null;
                              },
                              onChanged: (_) => setState(() {}),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        S.of(context).egyptMobileHint,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                      ),
                      BlocBuilder<EditPhoneCubit, EditPhoneState>(
                        builder: (context, state) {
                          if (state is! EditPhoneFailure) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 14.h),
                            child: Text(
                              _errorMessage(context, state.errorType),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.error,
                                fontSize: 13.sp,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30.h),
                      BlocBuilder<EditPhoneCubit, EditPhoneState>(
                        builder: (context, state) {
                          final isLoading = state is EditPhoneLoading;
                          final isValid =
                              normalizeEgyptianMobileNumber(
                                _phoneController.text,
                              ) !=
                              null;
                          return SizedBox(
                            height: 54.h,
                            child: FilledButton(
                              onPressed: isLoading || !isValid
                                  ? null
                                  : () {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      FocusScope.of(context).unfocus();
                                      context.read<EditPhoneCubit>().savePhone(
                                        _phoneController.text,
                                      );
                                    },
                              style: FilledButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                disabledBackgroundColor: colors.onSurface
                                    .withValues(alpha: 0.12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 22.r,
                                      height: 22.r,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: colors.onPrimary,
                                      ),
                                    )
                                  : Text(
                                      S.of(context).savePhoneNumber,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _errorMessage(BuildContext context, AppErrorType errorType) {
    final strings = S.of(context);
    return switch (errorType) {
      AppErrorType.validation => strings.phoneUpdateValidationError,
      AppErrorType.profileUnavailable => strings.phoneProfileUnavailable,
      AppErrorType.network ||
      AppErrorType.timeout => strings.phoneUpdateNetworkError,
      AppErrorType.unauthorized ||
      AppErrorType.forbidden => strings.phoneUpdateAuthError,
      AppErrorType.server => strings.phoneUpdateServerError,
      _ => strings.phoneUpdateGenericError,
    };
  }
}

class _EgyptCountryCode extends StatelessWidget {
  const _EgyptCountryCode();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Text(
        '+20',
        textDirection: TextDirection.ltr,
        style: TextStyle(
          color: colors.primary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
