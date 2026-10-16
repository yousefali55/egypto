import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SubMainText extends StatelessWidget {
  final String text;
  const SubMainText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.w400),
    );
  }
}
