import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:querosermb/core/dependency_injection.dart';
import 'package:querosermb/core/theme/app_colors.dart';
import 'package:querosermb/core/theme/app_sizes.dart';
import 'package:querosermb/core/theme/app_text_styles.dart';
import '../bloc/exchange_assets_bloc.dart';
import '../bloc/exchange_assets_event.dart';
import '../bloc/exchange_assets_state.dart';
import '../../domain/entities/exchange_asset.dart';

class ExchangeAssetsWidget extends StatelessWidget {
  final int exchangeId;

  const ExchangeAssetsWidget({
    super.key,
    required this.exchangeId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExchangeAssetsBloc>(
      create: (_) => DependencyInjection.exchangeAssetsBloc
        ..add(LoadExchangeAssets(exchangeId)),
      child: BlocBuilder<ExchangeAssetsBloc, ExchangeAssetsState>(
        builder: (context, state) {
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
                _buildHeader(context, state),
                const SizedBox(height: AppSizes.lg),
                _buildContent(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ExchangeAssetsState state) {
    return Row(
      children: [
        Icon(
          Icons.account_balance_wallet,
          color: AppColors.primary,
          size: AppSizes.iconLg,
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text(
            'Assets da Exchange',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (state is ExchangeAssetsLoaded) ...[
          IconButton(
            onPressed: () {
              context.read<ExchangeAssetsBloc>().add(RefreshExchangeAssets(exchangeId));
            },
            icon: Icon(
              Icons.refresh,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContent(BuildContext context, ExchangeAssetsState state) {
    if (state is ExchangeAssetsLoading) {
      return _buildLoading();
    } else if (state is ExchangeAssetsError) {
      return _buildError(context, state.message);
    } else if (state is ExchangeAssetsEmpty) {
      return _buildEmpty();
    } else if (state is ExchangeAssetsLoaded) {
      return _buildAssetsList(state.assets);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoading() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Text(
                'Carregando assets...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Erro ao carregar assets',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.md),
                ElevatedButton(
                  onPressed: () {
                    context.read<ExchangeAssetsBloc>().add(LoadExchangeAssets(exchangeId));
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Nenhum asset encontrado',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Esta exchange não possui assets disponíveis no momento.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetsList(List<ExchangeAsset> assets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  '${assets.length} asset${assets.length != 1 ? 's' : ''} encontrado${assets.length != 1 ? 's' : ''}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        // Show first 3 assets with option to expand
        ...assets.take(3).map((asset) => Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: _buildAssetItem(asset),
        )),
        if (assets.length > 3) ...[
          const SizedBox(height: AppSizes.sm),
          Builder(
            builder: (context) => Center(
              child: TextButton.icon(
                onPressed: () => _showAllAssetsDialog(context, assets),
                icon: Icon(Icons.visibility, size: 16),
                label: Text('Ver todos os ${assets.length} assets'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showAllAssetsDialog(BuildContext context, List<ExchangeAsset> assets) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      'Todos os Assets (${assets.length})',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              Expanded(
                child: ListView.separated(
                  itemCount: assets.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
                  itemBuilder: (context, index) {
                    return _buildAssetItem(assets[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssetItem(ExchangeAsset asset) {
    final totalValue = asset.balance * asset.currency.priceUsd;
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    asset.currency.symbol.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.currency.name,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      asset.currency.symbol,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${asset.currency.priceUsd.toStringAsFixed(6)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Por unidade',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Container(
            height: 1,
            color: AppColors.border,
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Saldo',
                  _formatBalance(asset.balance),
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _buildInfoItem(
                  'Valor Total',
                  '\$${_formatBalance(totalValue)}',
                  Icons.attach_money,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Plataforma',
                  '${asset.platform.name} (${asset.platform.symbol})',
                  Icons.layers,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          _buildInfoItem(
            'Endereço da Carteira',
            _truncateAddress(asset.walletAddress),
            Icons.wallet,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatBalance(double balance) {
    if (balance >= 1000000000) {
      return '${(balance / 1000000000).toStringAsFixed(2)}B';
    } else if (balance >= 1000000) {
      return '${(balance / 1000000).toStringAsFixed(2)}M';
    } else if (balance >= 1000) {
      return '${(balance / 1000).toStringAsFixed(2)}K';
    } else {
      return balance.toStringAsFixed(2);
    }
  }

  String _truncateAddress(String address) {
    if (address.length <= 16) return address;
    return '${address.substring(0, 8)}...${address.substring(address.length - 8)}';
  }
}
