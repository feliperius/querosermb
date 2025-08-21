import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/exchange.dart';
import '../bloc/exchange_bloc.dart';
import '../bloc/exchange_event.dart';
import '../bloc/exchange_state.dart';

class ExchangeDetailPage extends StatelessWidget {
  final int exchangeId;

  const ExchangeDetailPage({
    super.key,
    required this.exchangeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Exchange'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<ExchangeBloc, ExchangeState>(
        builder: (context, state) {
          if (state is ExchangeInitial) {
            context.read<ExchangeBloc>().add(LoadExchangeById(exchangeId));
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
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar detalhes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExchangeBloc>().add(LoadExchangeById(exchangeId));
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }
          
          if (state is ExchangeLoaded && state.exchanges.isNotEmpty) {
            final exchange = state.exchanges.first;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExchangeHeader(exchange: exchange),
                  const SizedBox(height: 24),
                  ExchangeDetails(exchange: exchange),
                  if (exchange.currencies.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    CurrencyList(currencies: exchange.currencies),
                  ],
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ExchangeHeader extends StatelessWidget {
  final Exchange exchange;

  const ExchangeHeader({super.key, required this.exchange});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (exchange.logo != null)
              CachedNetworkImage(
                imageUrl: exchange.logo!,
                width: 60,
                height: 60,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            else
              const Icon(Icons.account_balance, size: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exchange.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('ID: ${exchange.id}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExchangeDetails extends StatelessWidget {
  final Exchange exchange;

  const ExchangeDetails({super.key, required this.exchange});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (exchange.description != null) ...[
              DetailRow(
                label: 'Descrição',
                value: exchange.description!,
              ),
              const SizedBox(height: 12),
            ],
            if (exchange.website != null) ...[
              DetailRow(
                label: 'Website',
                value: exchange.website!,
                isLink: true,
              ),
              const SizedBox(height: 12),
            ],
            if (exchange.makerFee != null) ...[
              DetailRow(
                label: 'Taxa Maker',
                value: '${exchange.makerFee}%',
              ),
              const SizedBox(height: 12),
            ],
            if (exchange.takerFee != null) ...[
              DetailRow(
                label: 'Taxa Taker',
                value: '${exchange.takerFee}%',
              ),
              const SizedBox(height: 12),
            ],
            if (exchange.dateLaunched != null) ...[
              DetailRow(
                label: 'Data de Lançamento',
                value: exchange.dateLaunched!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: isLink
              ? GestureDetector(
                  onTap: () => _launchUrl(value),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(value),
        ),
      ],
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class CurrencyList extends StatelessWidget {
  final List<Currency> currencies;

  const CurrencyList({super.key, required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Moedas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currencies.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return ListTile(
                  title: Text(currency.name),
                  trailing: currency.priceUsd != null
                      ? Text(
                          '\$${currency.priceUsd!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        )
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
