// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeModel _$ExchangeModelFromJson(Map<String, dynamic> json) =>
    ExchangeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      logo: json['logo'] as String?,
      spotVolumeUsd: (json['spot_volume_usd'] as num?)?.toDouble(),
      dateLaunched: json['date_launched'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      makerFee: (json['maker_fee'] as num?)?.toDouble(),
      takerFee: (json['taker_fee'] as num?)?.toDouble(),
      currencies:
          (json['currencies'] as List<dynamic>?)
              ?.map((e) => CurrencyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ExchangeModelToJson(ExchangeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'spot_volume_usd': instance.spotVolumeUsd,
      'date_launched': instance.dateLaunched,
      'description': instance.description,
      'website': instance.website,
      'maker_fee': instance.makerFee,
      'taker_fee': instance.takerFee,
      'currencies': instance.currencies,
    };

CurrencyModel _$CurrencyModelFromJson(Map<String, dynamic> json) =>
    CurrencyModel(
      name: json['name'] as String,
      priceUsd: (json['price_usd'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CurrencyModelToJson(CurrencyModel instance) =>
    <String, dynamic>{'name': instance.name, 'price_usd': instance.priceUsd};
