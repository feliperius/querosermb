import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:querosermb/core/navigation/app_router.dart';
import 'package:querosermb/core/theme/app_sizes.dart';
import 'package:querosermb/features/list_exchanges/data/models/exchange_model.dart';
import 'package:querosermb/features/list_exchanges/domain/entities/exchange.dart';
import 'package:querosermb/features/list_exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:querosermb/features/list_exchanges/presentation/bloc/exchange_event.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/exchange_list_item.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/loading_widgets.dart';

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
    final initialModel = ExchangeModel(
      id: exchange.id,
      name: exchange.name,
      logo: exchange.logo,
      spotVolumeUsd: exchange.spotVolumeUsd,
      dateLaunched: exchange.dateLaunched,
      description: exchange.description,
      website: exchange.website,
      makerFee: exchange.makerFee,
      takerFee: exchange.takerFee,
      currencies: exchange.currencies
          .map((c) => CurrencyModel(name: c.name, priceUsd: c.priceUsd))
          .toList(),
    );

    AppRouter.pushExchangeDetail(
      context,
      exchangeId: exchange.id,
      initialModel: initialModel,
    );
  }

}

