import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginOrRegisterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  const LoginOrRegisterButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 60.h,
      width: 410.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onPressed,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonText,
                style: GoogleFonts.cairo(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.login, color: theme.colorScheme.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
