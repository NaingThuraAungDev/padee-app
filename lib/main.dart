import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const PadeeApp());
}

class PadeeApp extends StatelessWidget {
  const PadeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Padee Counter',
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
