import 'package:dio/dio.dart';
import '../models/exchange_model.dart';
import 'exchange_remote_data_source.dart';

class ExchangeRemoteDataSourceImpl implements ExchangeRemoteDataSource {
  final Dio dio;
  final String apiKey;

  ExchangeRemoteDataSourceImpl({
    required this.dio,
    required this.apiKey,
  });

  @override
  Future<List<ExchangeModel>> getExchanges() async {
    try {
      final response = await dio.get(
        'https://pro-api.coinmarketcap.com/v1/exchange/listings/latest',
        options: Options(
          headers: {
            'X-CMC_PRO_API_KEY': apiKey,
            'Accept': 'application/json',
          },
        ),
      );

      final List<dynamic> data = response.data['data'];
      return data.map((json) => ExchangeModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load exchanges: $e');
    }
  }

  @override
  Future<ExchangeModel> getExchangeById(int id) async {
    try {
      final response = await dio.get(
        'https://pro-api.coinmarketcap.com/v1/exchange/info',
        queryParameters: {'id': id},
        options: Options(
          headers: {
            'X-CMC_PRO_API_KEY': apiKey,
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data['data'][id.toString()];
      
      final exchangeResponse = await dio.get(
        'https://pro-api.coinmarketcap.com/v1/exchange/market-pairs/latest',
        queryParameters: {'id': id},
        options: Options(
          headers: {
            'X-CMC_PRO_API_KEY': apiKey,
            'Accept': 'application/json',
          },
        ),
      );

      final currencies = <CurrencyModel>[];
      final marketPairs = exchangeResponse.data['data']['market_pairs'] as List;
      
      for (final pair in marketPairs) {
        final quote = pair['quote'];
        if (quote != null && quote['USD'] != null) {
          currencies.add(CurrencyModel(
            name: pair['market_pair'] ?? '',
            priceUsd: quote['USD']['price']?.toDouble(),
          ));
        }
      }

      return ExchangeModel(
        id: data['id'],
        name: data['name'],
        logo: data['logo'],
        spotVolumeUsd: data['spot_volume_usd']?.toDouble(),
        dateLaunched: data['date_launched'],
        description: data['description'],
        website: data['urls']?['website']?.first,
        makerFee: data['maker_fee']?.toDouble(),
        takerFee: data['taker_fee']?.toDouble(),
        currencies: currencies,
      );
    } catch (e) {
      throw Exception('Failed to load exchange details: $e');
    }
  }
}
