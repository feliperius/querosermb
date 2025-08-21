import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/exchange.dart';
import '../bloc/exchange_bloc.dart';
import '../bloc/exchange_event.dart';
import '../bloc/exchange_state.dart';
import 'exchange_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ExchangeBloc>().add(const LoadMoreExchanges());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Exchanges',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              context.read<ExchangeBloc>().add(const LoadExchanges(refresh: true));
            },
            icon: const Icon(
              Icons.refresh,
              color: AppColors.primary,
            ),
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: BlocBuilder<ExchangeBloc, ExchangeState>(
        builder: (context, state) {
          if (state is ExchangeInitial) {
            context.read<ExchangeBloc>().add(const LoadExchanges());
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is ExchangeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is ExchangeError) {
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
                    state.message,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.md),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExchangeBloc>().add(const LoadExchanges());
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }
          
          if (state is ExchangeLoaded || state is ExchangeLoadingMore) {
            final exchanges = state is ExchangeLoaded 
                ? state.exchanges 
                : (state as ExchangeLoadingMore).currentExchanges;
            
            final hasReachedMax = state is ExchangeLoaded 
                ? state.hasReachedMax 
                : false;
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExchangeBloc>().add(const LoadExchanges(refresh: true));
              },
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSizes.md),
                itemCount: hasReachedMax 
                    ? exchanges.length 
                    : exchanges.length + 1,
                separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
                itemBuilder: (context, index) {
                  if (index >= exchanges.length) {
                    return Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  
                  final exchange = exchanges[index];
                  return ExchangeListItem(
                    exchange: exchange,
                    onTap: () {
                      final bloc = context.read<ExchangeBloc>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExchangeDetailPage(
                            exchangeId: exchange.id,
                            exchangeBloc: bloc,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

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
    return Card(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              // Logo Container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  color: AppColors.background,
                  border: Border.all(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: exchange.logo != null && exchange.logo!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: exchange.logo!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 56,
                            height: 56,
                            color: AppColors.background,
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 56,
                            height: 56,
                            color: AppColors.background,
                            child: const Icon(
                              Icons.account_balance,
                              color: AppColors.textMuted,
                              size: 24,
                            ),
                          ),
                        )
                      : Container(
                          width: 56,
                          height: 56,
                          color: AppColors.background,
                          child: const Icon(
                            Icons.account_balance,
                            color: AppColors.textMuted,
                            size: 24,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(width: AppSizes.md),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exchange Name
                    Text(
                      exchange.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppSizes.xs),
                    
                    // Volume
                    if (exchange.spotVolumeUsd != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Text(
                          'Volume: ${_formatCurrency(exchange.spotVolumeUsd!)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textMuted.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Text(
                          'Volume: N/A',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: AppSizes.xs),
                    
                    // Date Launched
                    if (exchange.dateLaunched != null)
                      Text(
                        'Lançado em: ${_formatDate(exchange.dateLaunched!)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      )
                    else
                      Text(
                        'Data de lançamento: N/A',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Arrow Icon
              Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: AppSizes.iconSm,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1e12) {
      return '\$${(value / 1e12).toStringAsFixed(1)}T';
    } else if (value >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(1)}M';
    } else if (value >= 1e3) {
      return '\$${(value / 1e3).toStringAsFixed(1)}K';
    } else {
      return '\$${value.toStringAsFixed(2)}';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
