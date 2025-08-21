import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

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
            'Erro ao carregar exchanges',
            style: AppTextStyles.headlineSmall,
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
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
