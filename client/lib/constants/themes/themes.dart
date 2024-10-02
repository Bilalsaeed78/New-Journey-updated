import 'package:flutter/material.dart';

import 'app_colors.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: Colors.white,
  primaryContainer: AppColors.primaryLight,
  onPrimaryContainer: Colors.black,
  secondary: AppColors.secondary,
  onSecondary: Colors.white,
  secondaryContainer: AppColors.secondaryLight,
  onSecondaryContainer: Colors.black,
  tertiary: AppColors.subtitleColor,
  onTertiary: Colors.white,
  tertiaryContainer: AppColors.propertyContainer,
  onTertiaryContainer: Colors.black,
  error: AppColors.error,
  errorContainer: Color(0xFFFFDAD6),
  onError: Colors.white,
  onErrorContainer: Color(0xFF410002),
  surface: AppColors.background,
  onSurface: AppColors.fontTitle,
  // surfaceContainerHighest: AppColors.propertyContainer,
  onSurfaceVariant: AppColors.fontSubtitle,
  outline: AppColors.divider,
  onInverseSurface: Colors.white,
  inverseSurface: AppColors.fontTitle,
  inversePrimary: AppColors.primary,
  shadow: Colors.black,
  surfaceTint: AppColors.primary,
  outlineVariant: AppColors.divider,
  scrim: Colors.black, background: AppColors.background, onBackground: AppColors.background,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.primary,
  onPrimary: Colors.black,
  primaryContainer: AppColors.primaryLight,
  onPrimaryContainer: Colors.white,
  secondary: AppColors.secondary,
  onSecondary: Colors.black,
  secondaryContainer: AppColors.secondaryLight,
  onSecondaryContainer: Colors.white,
  tertiary: AppColors.subtitleColor,
  onTertiary: Colors.black,
  tertiaryContainer: AppColors.propertyContainer,
  onTertiaryContainer: Colors.white,
  error: AppColors.error,
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: AppColors.fontTitle,
  onSurface: AppColors.background,
  // surfaceContainerHighest: AppColors.propertyContainer,
  onSurfaceVariant: AppColors.fontSubtitle,
  outline: AppColors.divider,
  onInverseSurface: AppColors.fontTitle,
  inverseSurface: AppColors.background,
  inversePrimary: AppColors.primary,
  shadow: Colors.black,
  surfaceTint: AppColors.primary,
  outlineVariant: AppColors.divider,
  scrim: Colors.black, background: AppColors.background, onBackground: AppColors.background,
);

ThemeData themeLight(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    dividerColor: AppColors.divider,
  );
}

ThemeData themeDark(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: AppColors.fontTitle,
    cardColor: AppColors.fontTitle,
    dividerColor: AppColors.divider,
  );
}
