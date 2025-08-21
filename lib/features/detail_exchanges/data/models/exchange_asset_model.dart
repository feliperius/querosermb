import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/exchange_asset.dart';

part 'exchange_asset_model.g.dart';

@JsonSerializable()
class ExchangeAssetModel {
  @JsonKey(name: 'wallet_address')
  final String walletAddress;
  final double balance;
  final PlatformModel platform;
  final AssetCurrencyModel currency;

  const ExchangeAssetModel({
    required this.walletAddress,
    required this.balance,
    required this.platform,
    required this.currency,
  });

  factory ExchangeAssetModel.fromJson(Map<String, dynamic> json) => 
      _$ExchangeAssetModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeAssetModelToJson(this);

  ExchangeAsset toEntity() {
    return ExchangeAsset(
      walletAddress: walletAddress,
      balance: balance,
      platform: platform.toEntity(),
      currency: currency.toEntity(),
    );
  }
}

@JsonSerializable()
class PlatformModel {
  @JsonKey(name: 'crypto_id')
  final int cryptoId;
  final String symbol;
  final String name;

  const PlatformModel({
    required this.cryptoId,
    required this.symbol,
    required this.name,
  });

  factory PlatformModel.fromJson(Map<String, dynamic> json) => 
      _$PlatformModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformModelToJson(this);

  Platform toEntity() {
    return Platform(
      cryptoId: cryptoId,
      symbol: symbol,
      name: name,
    );
  }
}

@JsonSerializable()
class AssetCurrencyModel {
  @JsonKey(name: 'crypto_id')
  final int cryptoId;
  @JsonKey(name: 'price_usd')
  final double priceUsd;
  final String symbol;
  final String name;

  const AssetCurrencyModel({
    required this.cryptoId,
    required this.priceUsd,
    required this.symbol,
    required this.name,
  });

  factory AssetCurrencyModel.fromJson(Map<String, dynamic> json) => 
      _$AssetCurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetCurrencyModelToJson(this);

  AssetCurrency toEntity() {
    return AssetCurrency(
      cryptoId: cryptoId,
      priceUsd: priceUsd,
      symbol: symbol,
      name: name,
    );
  }
}
