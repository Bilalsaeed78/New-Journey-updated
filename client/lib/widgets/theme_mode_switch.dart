import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/constants/themes/app_colors.dart';
import '../constants/themes/themes.dart';
import '../controllers/theme_controller.dart';

class ThemeModeSwitch extends StatefulWidget {
  const ThemeModeSwitch({super.key});

  @override
  State<ThemeModeSwitch> createState() => _ThemeModeSwitchState();
}

class _ThemeModeSwitchState extends State<ThemeModeSwitch> {
  final controller = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: Get.width * 0.04),
        Icon(
          controller.isDarkMode
              ? Icons.nightlight_round
              : Icons.wb_sunny_rounded,
          size: 24.0,
          color: AppColors.primary,
        ),
        SizedBox(width: Get.width * 0.08),
        Switch(
          value: controller.isDarkMode,
          onChanged: (_) {
            setState(() {
              controller.toggleTheme();
            });
          },
          activeColor: controller.isDarkMode
              ? darkColorScheme.primary
              : lightColorScheme.primaryContainer,
          inactiveTrackColor: controller.isDarkMode
              ? darkColorScheme.primary.withOpacity(0.5)
              : lightColorScheme.primaryContainer.withOpacity(0.5),
          inactiveThumbColor: darkColorScheme.primary,
        ),
      ],
    );
  }
}
