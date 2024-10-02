import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/controllers/auth_controller.dart';

import '../constants/themes/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => authController.checkLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: isDarkMode
                  ? SvgPicture.asset(
                      'assets/icons/logos_svg/full_dark.svg',
                      height: 350,
                      width: 350,
                      fit: BoxFit.scaleDown,
                    )
                  : SvgPicture.asset(
                      'assets/icons/logos_svg/full.svg',
                      height: 300,
                      width: 300,
                      fit: BoxFit.scaleDown,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
