import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: isDark ? const [0.0, 0.28, 0.48] : const [0.0, 0.45, 0.65],
          colors: isDark
              ? const [Color(0xFF182519), Color(0xFF101610), Color(0xFF0D0F0D)]
              : const [Color(0xFFD9E79D), Color(0xFFF7F9EE), Colors.white],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
