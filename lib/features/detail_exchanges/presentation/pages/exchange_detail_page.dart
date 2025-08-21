import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:querosermb/core/dependency_injection.dart';
import 'package:querosermb/core/theme/app_colors.dart';
import 'package:querosermb/core/theme/app_sizes.dart';
import 'package:querosermb/core/theme/app_text_styles.dart';
import 'package:querosermb/features/detail_exchanges/presentation/bloc/detail_exchange_bloc.dart';
import 'package:querosermb/features/detail_exchanges/presentation/bloc/detail_exchange_event.dart';
import 'package:querosermb/features/detail_exchanges/presentation/bloc/detail_exchange_state.dart';
import 'package:querosermb/features/list_exchanges/data/models/exchange_model.dart';
import 'package:querosermb/features/list_exchanges/domain/entities/exchange.dart';
import 'package:url_launcher/url_launcher.dart';

class ExchangeDetailScreen extends StatelessWidget {
  final int exchangeId;
  final ExchangeModel? initialExchangeModel;

  const ExchangeDetailScreen({
    super.key,
    required this.exchangeId,
    this.initialExchangeModel,
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
  body: BlocProvider<DetailExchangeBloc>(
        create: (_) => DependencyInjection.detailExchangeBloc(exchangeId),
        child: BlocBuilder<DetailExchangeBloc, DetailExchangeState>(
          builder: (context, state) {
            // On initial build, trigger load and render initial model if provided
            if (state is DetailExchangeInitial) {
              context.read<DetailExchangeBloc>().add(LoadDetailExchange(exchangeId));
              if (initialExchangeModel != null) {
                return _buildContent(context, initialExchangeModel!.toEntity());
              }
              return _buildLoading();
            }

            // While loading, prefer showing the passed initial model if available
            if (state is DetailExchangeLoading) {
              if (initialExchangeModel != null) {
                return _buildContent(context, initialExchangeModel!.toEntity());
              }
              return _buildLoading();
            }

            if (state is DetailExchangeError) {
              if (initialExchangeModel != null) {
                return _buildContent(context, initialExchangeModel!.toEntity());
              }
              return _buildError(context, state.message);
            }

            if (state is DetailExchangeLoaded) {
              return _buildContent(context, state.exchange);
            }

            return _buildError(context, 'Estado não reconhecido');
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonHeader(),
          const SizedBox(height: AppSizes.lg),
          _buildSkeletonCard(height: 200),
          const SizedBox(height: AppSizes.lg),
          _buildSkeletonCard(height: 120),
          const SizedBox(height: AppSizes.lg),
          _buildSkeletonCard(height: 300),
          const SizedBox(height: AppSizes.xl),
          Center(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: AppSizes.borderThin,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Text(
                    'Carregando detalhes da exchange...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonHeader() {
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
      child: Row(
        children: [
          // Logo skeleton
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            child: const _ShimmerEffect(),
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const _ShimmerEffect(),
                ),
                const SizedBox(height: AppSizes.sm),
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const _ShimmerEffect(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard({required double height}) {
    return Container(
      height: height,
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
          Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const _ShimmerEffect(),
          ),
          const SizedBox(height: AppSizes.lg),
          Expanded(
            child: Column(
              children: List.generate(3, (index) => Padding(
                padding: EdgeInsets.only(bottom: AppSizes.md),
                child: Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const _ShimmerEffect(),
                ),
              )),
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
              context.read<DetailExchangeBloc>().add(LoadDetailExchange(exchangeId));
            },
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Exchange exchange) {
    return RefreshIndicator(
      onRefresh: () async {
  context.read<DetailExchangeBloc>().add(LoadDetailExchange(exchangeId));
      },
      backgroundColor: AppColors.cardBackground,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEnhancedHeader(exchange),
            const SizedBox(height: AppSizes.lg),
            _buildStatsRow(exchange),
            const SizedBox(height: AppSizes.lg),
            _buildInfoCard(exchange),
            const SizedBox(height: AppSizes.lg),
            _buildFeesCard(exchange),
            if (exchange.currencies.isNotEmpty) ...[
              const SizedBox(height: AppSizes.lg),
              _buildCurrenciesCard(exchange.currencies),
            ],
            // Extra space at bottom
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(Exchange exchange) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
            AppColors.cardBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Enhanced Logo Container
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      AppColors.secondary.withOpacity(0.2),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                  child: Builder(
                    builder: (context) {
                      final size = 90.0;
                      if (exchange.logo != null && exchange.logo!.isNotEmpty) {
                        return CachedNetworkImage(
                          imageUrl: exchange.logo!,
                          width: size,
                          height: size,
                          imageBuilder: (context, imageProvider) => Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: size,
                            height: size,
                            color: AppColors.surface.withOpacity(0.5),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: size,
                            height: size,
                            color: AppColors.surface.withOpacity(0.5),
                            child: const Icon(Icons.account_balance, color: AppColors.primary, size: 40),
                          ),
                        );
                      }

                      return Container(
                        width: size,
                        height: size,
                        color: AppColors.surface.withOpacity(0.5),
                        child: const Icon(Icons.account_balance, color: AppColors.primary, size: 40),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exchange.name,
                      style: AppTextStyles.headlineMedium.copyWith(
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
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.secondary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tag,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Text(
                            'ID: ${exchange.id}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (exchange.dateLaunched != null && exchange.dateLaunched!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.lg),
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                  color: AppColors.border,
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    'Lançado em: ${_formatDate(exchange.dateLaunched!)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(Exchange exchange) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_up,
            label: 'Maker Fee',
            value: exchange.makerFee != null ? '${exchange.makerFee}%' : 'N/A',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_down,
            label: 'Taker Fee',
            value: exchange.takerFee != null ? '${exchange.takerFee}%' : 'N/A',
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: _buildStatCard(
            icon: Icons.currency_bitcoin,
            label: 'Moedas',
            value: '${exchange.currencies.length}',
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
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
          if (exchange.description != null && exchange.description!.isNotEmpty) ...[
            _buildInfoRow('Descrição', exchange.description!),
            const SizedBox(height: AppSizes.md),
          ],
          if (exchange.website != null && exchange.website!.isNotEmpty) ...[
            _buildWebsiteRow('Website', exchange.website!),
            const SizedBox(height: AppSizes.md),
          ],
          if (exchange.dateLaunched != null && exchange.dateLaunched!.isNotEmpty) ...[
            _buildInfoRow('Data de Lançamento', _formatDate(exchange.dateLaunched!)),
          ],
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
          ...currencies.map((currency) => _buildCurrencyItem(currency)),
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

  Widget _buildWebsiteRow(String label, String url) {
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
        GestureDetector(
          onTap: () => _launchUrl(url),
          child: Text(
            url,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeeItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

// Shimmer Effect Widget for Loading Animation
class _ShimmerEffect extends StatefulWidget {
  const _ShimmerEffect();

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
              colors: [
                AppColors.surface,
                AppColors.surface.withOpacity(0.5),
                AppColors.surface,
              ],
            ),
          ),
        );
      },
    );
  }
}
