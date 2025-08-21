import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/exchange.dart';
import '../bloc/exchange_bloc.dart';
import '../bloc/exchange_event.dart';
import '../bloc/exchange_state.dart';
import 'exchange_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchanges'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<ExchangeBloc, ExchangeState>(
        builder: (context, state) {
          if (state is ExchangeInitial) {
            context.read<ExchangeBloc>().add(LoadExchanges());
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
                    'Erro ao carregar exchanges',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExchangeBloc>().add(LoadExchanges());
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }
          
          if (state is ExchangeLoaded) {
            return ListView.builder(
              itemCount: state.exchanges.length,
              itemBuilder: (context, index) {
                final exchange = state.exchanges[index];
                return ExchangeListItem(
                  exchange: exchange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExchangeDetailPage(
                          exchangeId: exchange.id,
                        ),
                      ),
                    );
                  },
                );
              },
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: exchange.logo != null
            ? CachedNetworkImage(
                imageUrl: exchange.logo!,
                width: 40,
                height: 40,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : const Icon(Icons.account_balance, size: 40),
        title: Text(
          exchange.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exchange.spotVolumeUsd != null)
              Text('Volume: \$${exchange.spotVolumeUsd!.toStringAsFixed(2)}'),
            if (exchange.dateLaunched != null)
              Text('Lançado em: ${exchange.dateLaunched}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
