import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/exchange.dart';

part 'exchange_model.g.dart';

@JsonSerializable()
class ExchangeModel {
  final int id;
  final String name;
  final String? logo;
  @JsonKey(name: 'spot_volume_usd')
  final double? spotVolumeUsd;
  @JsonKey(name: 'date_launched')
  final String? dateLaunched;
  final String? description;
  final String? website;
  @JsonKey(name: 'maker_fee')
  final double? makerFee;
  @JsonKey(name: 'taker_fee')
  final double? takerFee;
  final List<CurrencyModel> currencies;

  const ExchangeModel({
    required this.id,
    required this.name,
    this.logo,
    this.spotVolumeUsd,
    this.dateLaunched,
    this.description,
    this.website,
    this.makerFee,
    this.takerFee,
    this.currencies = const [],
  });

  factory ExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeModelToJson(this);

  factory ExchangeModel.fromInfo(Map<String, dynamic> json) {
    final urls = json['urls'] as Map<String, dynamic>?;
    final website = (urls?['website'] as List?)?.isNotEmpty == true
        ? urls!['website'].first as String
        : null;

    return ExchangeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
      spotVolumeUsd: (json['spot_volume_usd'] as num?)?.toDouble(),
      dateLaunched: json['date_launched'] as String?,
      description: json['description'] as String?,
      website: website,
      makerFee: (json['maker_fee'] as num?)?.toDouble(),
      takerFee: (json['taker_fee'] as num?)?.toDouble(),
      currencies: const [],
    );
  }

  Exchange toEntity() {
    return Exchange(
      id: id,
      name: name,
      logo: logo,
      spotVolumeUsd: spotVolumeUsd,
      dateLaunched: dateLaunched,
      description: description,
      website: website,
      makerFee: makerFee,
      takerFee: takerFee,
      currencies: currencies.map((c) => c.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class CurrencyModel {
  final String name;
  @JsonKey(name: 'price_usd')
  final double? priceUsd;

  const CurrencyModel({
    required this.name,
    this.priceUsd,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);

  Currency toEntity() {
    return Currency(
      name: name,
      priceUsd: priceUsd,
    );
  }
}
