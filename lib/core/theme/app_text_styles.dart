import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

class AppTextStyles {
  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: AppSizes.fontDisplay,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: AppSizes.fontHeading,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: AppSizes.fontTitle,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: AppSizes.fontXxxl,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: AppSizes.fontXxl,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: AppSizes.fontXl,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // Button styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: AppSizes.fontLg,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );
  
  // Special styles
  static const TextStyle caption = TextStyle(
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );
  
  static const TextStyle overline = TextStyle(
    fontSize: AppSizes.fontXs,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 1.5,
  );
  
  static const TextStyle link = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.4,
    decoration: TextDecoration.underline,
  );
  
  static const TextStyle error = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
    height: 1.4,
  );
  
  static const TextStyle success = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w400,
    color: AppColors.success,
    height: 1.4,
  );
  
  static const TextStyle warning = TextStyle(
    fontSize: AppSizes.fontSm,
    fontWeight: FontWeight.w400,
    color: AppColors.warning,
    height: 1.4,
  );
  
  // Price styles
  static const TextStyle pricePositive = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w600,
    color: AppColors.green,
    height: 1.4,
  );
  
  static const TextStyle priceNegative = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w600,
    color: AppColors.red,
    height: 1.4,
  );
  
  static const TextStyle priceNeutral = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
}
