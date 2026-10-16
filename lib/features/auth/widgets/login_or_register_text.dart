import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginOrRegisterText extends StatelessWidget {
  final String loginORRegisterText;
  final String actionText;
  final VoidCallback onTap;
  const LoginOrRegisterText({
    super.key,
    required this.loginORRegisterText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          loginORRegisterText,
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 10.w),
        InkWell(
          onTap: onTap,
          child: Text(
            actionText,
            style: GoogleFonts.cairo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
