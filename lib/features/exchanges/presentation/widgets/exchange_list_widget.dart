import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/exchange.dart';
import '../bloc/exchange_bloc.dart';
import '../bloc/exchange_event.dart';
import '../pages/exchange_detail_page.dart';
import 'exchange_list_item.dart';
import 'loading_widgets.dart';

class ExchangeListWidget extends StatelessWidget {
  final List<Exchange> exchanges;
  final bool hasReachedMax;
  final ScrollController scrollController;

  const ExchangeListWidget({
    super.key,
    required this.exchanges,
    required this.hasReachedMax,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ExchangeBloc>().add(const LoadExchanges(refresh: true));
      },
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: hasReachedMax ? exchanges.length : exchanges.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
        itemBuilder: (context, index) {
          if (index >= exchanges.length) {
            return const LoadingMoreWidget();
          }

          final exchange = exchanges[index];
          return ExchangeListItem(
            exchange: exchange,
            onTap: () => _navigateToDetails(context, exchange),
          );
        },
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Exchange exchange) {
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
  }
}
