import 'package:flutter/material.dart';
import 'package:querosermb/core/strings/app_strings.dart';
import 'package:querosermb/core/theme/app_colors.dart';
import 'package:querosermb/core/theme/app_sizes.dart';
import 'package:querosermb/core/theme/app_text_styles.dart';
import 'package:querosermb/features/list_exchanges/domain/entities/exchange.dart';

/// Mock version of ExchangeListItem for golden tests
/// Avoids CachedNetworkImage dependencies
class MockExchangeListItem extends StatelessWidget {
  final Exchange exchange;
  final VoidCallback onTap;

  const MockExchangeListItem({
    super.key,
    required this.exchange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBackground,
            AppColors.surfaceVariant,
          ],
        ),
        border: Border.all(
          color: AppColors.border,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Row(
              children: [
                _MockExchangeLogoWidget(exchange: exchange),
                const SizedBox(width: AppSizes.lg),
                Expanded(
                  child: _MockExchangeInfoWidget(exchange: exchange),
                ),
                const SizedBox(width: AppSizes.md),
                _MockExchangeArrowWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MockExchangeLogoWidget extends StatelessWidget {
  final Exchange exchange;

  const _MockExchangeLogoWidget({
    required this.exchange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.avatarXl,
      height: AppSizes.avatarXl,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: exchange.logo != null && exchange.logo!.isNotEmpty
            ? Container(
                color: AppColors.surface,
                child: Center(
                  child: Text(
                    exchange.name.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Container(
                color: AppColors.surface,
                child: Icon(
                  Icons.account_balance,
                  color: AppColors.textMuted,
                  size: AppSizes.iconLg,
                ),
              ),
      ),
    );
  }
}

class _MockExchangeInfoWidget extends StatelessWidget {
  final Exchange exchange;

  const _MockExchangeInfoWidget({
    required this.exchange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exchange.name,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.sm),
        _MockExchangeVolumeWidget(exchange: exchange),
        const SizedBox(height: AppSizes.sm),
        _MockExchangeDateWidget(exchange: exchange),
      ],
    );
  }
}

class _MockExchangeVolumeWidget extends StatelessWidget {
  final Exchange exchange;

  const _MockExchangeVolumeWidget({
    required this.exchange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.trending_up,
          size: AppSizes.iconXs,
          color: AppColors.success,
        ),
        const SizedBox(width: AppSizes.xs),
        Flexible(
          child: Text(
            AppStrings.formatVolume(exchange.spotVolumeUsd),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class _MockExchangeDateWidget extends StatelessWidget {
  final Exchange exchange;

  const _MockExchangeDateWidget({
    required this.exchange,
  });

  @override
  Widget build(BuildContext context) {
    if (exchange.dateLaunched != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: AppSizes.iconXs,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSizes.xs),
          Flexible(
            child: Text(
              _formatDate(exchange.dateLaunched!),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.help_outline,
            size: AppSizes.iconXs,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: AppSizes.xs),
          Flexible(
            child: Text(
              AppStrings.notAvailable,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final months = [
        'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
        'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return AppStrings.notAvailable;
    }
  }
}

class _MockExchangeArrowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.arrow_forward_ios,
        size: AppSizes.iconSm,
        color: AppColors.primary,
      ),
    );
  }
}
