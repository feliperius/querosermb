import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/exchange.dart';

class ExchangeListItem extends StatelessWidget {
  final Exchange exchange;
  final VoidCallback onTap;

  const ExchangeListItem({
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
            color: AppColors.primary.withOpacity(0.1),
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
                ExchangeLogoWidget(exchange: exchange),
                const SizedBox(width: AppSizes.lg),
                Expanded(
                  child: ExchangeInfoWidget(exchange: exchange),
                ),
                const SizedBox(width: AppSizes.md),
                ExchangeArrowWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExchangeLogoWidget extends StatelessWidget {
  final Exchange exchange;

  const ExchangeLogoWidget({
    super.key,
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
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: exchange.logo != null && exchange.logo!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: exchange.logo!,
                width: AppSizes.avatarLg,
                height: AppSizes.avatarLg,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: AppSizes.avatarLg,
                  height: AppSizes.avatarLg,
                  color: AppColors.background,
                  child: Center(
                    child: SizedBox(
                      width: AppSizes.loadingMd,
                      height: AppSizes.loadingMd,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.borderMedium,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: AppSizes.avatarLg,
                  height: AppSizes.avatarLg,
                  color: AppColors.background,
                  child: Icon(
                    Icons.account_balance,
                    color: AppColors.textMuted,
                    size: AppSizes.iconLg,
                  ),
                ),
              )
            : Container(
                width: AppSizes.avatarLg,
                height: AppSizes.avatarLg,
                color: AppColors.background,
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

class ExchangeInfoWidget extends StatelessWidget {
  final Exchange exchange;

  const ExchangeInfoWidget({
    super.key,
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
        ExchangeVolumeWidget(exchange: exchange),
        const SizedBox(height: AppSizes.sm),
        ExchangeDateWidget(exchange: exchange),
      ],
    );
  }
}

class ExchangeVolumeWidget extends StatelessWidget {
  final Exchange exchange;

  const ExchangeVolumeWidget({
    super.key,
    required this.exchange,
  });

  @override
  Widget build(BuildContext context) {
    if (exchange.spotVolumeUsd != null) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
            width: AppSizes.borderThin,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.trending_up,
              size: AppSizes.iconSm,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSizes.xs),
            Flexible(
              child: Text(
                'Volume: ${_formatCurrency(exchange.spotVolumeUsd!)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.textMuted.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.help_outline,
              size: AppSizes.iconSm,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: AppSizes.xs),
            Flexible(
              child: Text(
                'Volume: N/A',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    }
  }

  String _formatCurrency(double value) {
    if (value >= AppSizes.trillionThreshold) {
      return '\$${(value / AppSizes.trillionThreshold).toStringAsFixed(AppSizes.currencyDecimalPlaces)}T';
    } else if (value >= AppSizes.billionThreshold) {
      return '\$${(value / AppSizes.billionThreshold).toStringAsFixed(AppSizes.currencyDecimalPlaces)}B';
    } else if (value >= AppSizes.millionThreshold) {
      return '\$${(value / AppSizes.millionThreshold).toStringAsFixed(AppSizes.currencyDecimalPlaces)}M';
    } else if (value >= AppSizes.thousandThreshold) {
      return '\$${(value / AppSizes.thousandThreshold).toStringAsFixed(AppSizes.currencyDecimalPlaces)}K';
    } else {
      return '\$${value.toStringAsFixed(AppSizes.currencyFullDecimalPlaces)}';
    }
  }
}

class ExchangeDateWidget extends StatelessWidget {
  final Exchange exchange;

  const ExchangeDateWidget({
    super.key,
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
              'N/A',
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(AppSizes.datePadLength, AppSizes.datePadChar)}/${date.month.toString().padLeft(AppSizes.datePadLength, AppSizes.datePadChar)}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

class ExchangeArrowWidget extends StatelessWidget {
  const ExchangeArrowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.textMuted.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: const Icon(
        Icons.arrow_forward_ios,
        size: AppSizes.iconSm,
        color: AppColors.textMuted,
      ),
    );
  }
}
