import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MainText extends StatelessWidget {
  final String text;
  const MainText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cairo(fontSize: 25.sp, fontWeight: FontWeight.bold),
    );
  }
}
