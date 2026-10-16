import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppSkeltonizer extends StatelessWidget {
  final bool enabled;
  final Widget child;
  const AppSkeltonizer({super.key, required this.enabled, required this.child});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      effect: ShimmerEffect(),
      child: child,
    );
  }
}
