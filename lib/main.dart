import 'package:egypto/core/di/dependency_injection.dart';
import 'package:egypto/egypto_app.dart';
import 'package:egypto/utils/prefs_helper.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  await PrefsHelper.init();
  runApp(const EgyptoApp());
}
