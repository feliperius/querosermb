import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/exchange.dart';
import '../bloc/exchange_bloc.dart';
import '../bloc/exchange_event.dart';
import '../bloc/exchange_state.dart';

class ExchangeDetailTempPage extends StatelessWidget {
  final int exchangeId;
  final ExchangeBloc? exchangeBloc;

  const ExchangeDetailTempPage({
    super.key,
    required this.exchangeId,
    this.exchangeBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalhes da Exchange'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<ExchangeBloc, ExchangeState>(
        bloc: exchangeBloc ?? context.read<ExchangeBloc>(),
        builder: (context, state) {
          if (state is ExchangeInitial) {
            (exchangeBloc ?? context.read<ExchangeBloc>()).add(LoadExchangeById(exchangeId));
            return _buildLoading();
          }
          
          if (state is ExchangeLoading) {
            return _buildLoading();
          }
          
          if (state is ExchangeError) {
            return _buildError(context, state.message);
          }
          
          if (state is ExchangeDetailLoaded) {
            return _buildContent(context, state.exchange);
          }
          
          return _buildError(context, 'Estado não reconhecido');
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: AppSizes.borderThin,
              ),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: AppSizes.borderThick,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'Carregando detalhes...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: AppSizes.iconXxl, color: AppColors.error),
          const SizedBox(height: AppSizes.md),
          Text(
            'Erro ao carregar detalhes',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.lg),
          ElevatedButton(
            onPressed: () {
              (exchangeBloc ?? context.read<ExchangeBloc>()).add(LoadExchangeById(exchangeId));
            },
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Exchange exchange) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(exchange),
          const SizedBox(height: AppSizes.lg),
          _buildInfoCard(exchange),
          const SizedBox(height: AppSizes.lg),
          _buildFeesCard(exchange),
          if (exchange.currencies.isNotEmpty) ...[
            const SizedBox(height: AppSizes.lg),
            _buildCurrenciesCard(exchange.currencies),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(Exchange exchange) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBackground,
            AppColors.surfaceVariant,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
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
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: AppSizes.borderMedium,
              ),
            ),
            child: const Icon(
              Icons.account_balance,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exchange.name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: AppSizes.borderThin,
                    ),
                  ),
                  child: Text(
                    'ID: ${exchange.id}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Exchange exchange) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: AppSizes.iconLg,
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Informações',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          _buildInfoRow('Volume 24h', '\$${exchange.spotVolumeUsd?.toStringAsFixed(2) ?? 'N/A'}'),
          const SizedBox(height: AppSizes.md),
          _buildInfoRow('Data de Lançamento', exchange.dateLaunched ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildFeesCard(Exchange exchange) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.paid_outlined,
                color: AppColors.primary,
                size: AppSizes.iconLg,
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Taxas',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Expanded(
                child: _buildFeeItem(
                  'Maker Fee',
                  exchange.makerFee != null ? '${exchange.makerFee}%' : 'N/A',
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _buildFeeItem(
                  'Taker Fee',
                  exchange.takerFee != null ? '${exchange.takerFee}%' : 'N/A',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrenciesCard(List<Currency> currencies) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.currency_bitcoin,
                color: AppColors.primary,
                size: AppSizes.iconLg,
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Moedas (${currencies.length})',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          ...currencies.take(10).map((currency) => _buildCurrencyItem(currency)),
          if (currencies.length > 10)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.sm),
              child: Text(
                '... e mais ${currencies.length - 10} moedas',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFeeItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: AppSizes.borderThin,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyItem(Currency currency) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            currency.name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            currency.priceUsd != null ? '\$${currency.priceUsd!.toStringAsFixed(2)}' : 'N/A',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
