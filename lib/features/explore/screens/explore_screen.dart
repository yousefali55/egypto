import 'package:egypto/generated/l10n.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        S.of(context).explore,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}