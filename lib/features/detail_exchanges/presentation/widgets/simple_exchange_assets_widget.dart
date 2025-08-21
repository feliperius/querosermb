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

class SimpleExchangeAssetsWidget extends StatefulWidget {
  final int exchangeId;

  const SimpleExchangeAssetsWidget({
    super.key,
    required this.exchangeId,
  });

  @override
  State<SimpleExchangeAssetsWidget> createState() => _SimpleExchangeAssetsWidgetState();
}

class _SimpleExchangeAssetsWidgetState extends State<SimpleExchangeAssetsWidget> {
  late ExchangeAssetsBloc _bloc;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _bloc = DependencyInjection.exchangeAssetsBloc;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load assets only when the widget is actually displayed and in a stable state
    if (!_hasInitialized) {
      _hasInitialized = true;
      // Wait for the widget tree to be fully built before making the request
      Future.microtask(() {
        if (mounted) {
          _bloc.add(LoadExchangeAssets(widget.exchangeId));
        }
      });
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExchangeAssetsBloc>.value(
      value: _bloc,
      child: Container(
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
            _buildHeader(),
            const SizedBox(height: AppSizes.lg),
            BlocBuilder<ExchangeAssetsBloc, ExchangeAssetsState>(
              builder: (context, state) {
                return _buildContent(context, state);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.currency_bitcoin,
          color: AppColors.primary,
          size: AppSizes.iconLg,
        ),
        const SizedBox(width: AppSizes.sm),
        Text(
          'Assets da Exchange',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
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
    return Container(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 2,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Carregando assets...',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Container(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 32,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Erro ao carregar assets',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ExchangeAssetsBloc>().add(LoadExchangeAssets(widget.exchangeId));
              },
              child: Text(
                'Tentar novamente',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 32,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Nenhum asset encontrado',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetsList(List<ExchangeAsset> assets) {
    // Mostra apenas os primeiros 5 assets para não sobrecarregar a tela
    final displayAssets = assets.take(5).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (assets.length > 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              '${assets.length} asset${assets.length != 1 ? 's' : ''} encontrado${assets.length != 1 ? 's' : ''}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],
        ...displayAssets.map((asset) => _buildAssetItem(asset)),
        if (assets.length > 5) ...[
          const SizedBox(height: AppSizes.sm),
          Center(
            child: Text(
              '... e mais ${assets.length - 5} assets',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAssetItem(ExchangeAsset asset) {
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
        children: [
          // Ícone da moeda
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                asset.currency.symbol.length > 0 
                    ? asset.currency.symbol.substring(0, 1).toUpperCase()
                    : '?',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          // Nome da moeda
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.currency.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          // Preço em USD
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${_formatPrice(asset.currency.priceUsd)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'USD',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(2);
    } else if (price >= 1) {
      return price.toStringAsFixed(4);
    } else if (price >= 0.001) {
      return price.toStringAsFixed(6);
    } else {
      return price.toStringAsFixed(8);
    }
  }
}
