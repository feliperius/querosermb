import 'package:flutter/material.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';

class ExchangeErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ExchangeErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: AppSizes.iconXxl, color: AppColors.error),
          const SizedBox(height: AppSizes.md),
          Text(
            AppStrings.errorLoadingExchanges,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            message,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.md),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppStrings.tryAgain),
          ),
        ],
      ),
    );
  }
}
