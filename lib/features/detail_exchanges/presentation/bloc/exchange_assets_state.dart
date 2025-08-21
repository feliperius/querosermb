import 'package:equatable/equatable.dart';
import '../../domain/entities/exchange_asset.dart';

abstract class ExchangeAssetsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExchangeAssetsInitial extends ExchangeAssetsState {}

class ExchangeAssetsLoading extends ExchangeAssetsState {}

class ExchangeAssetsLoaded extends ExchangeAssetsState {
  final List<ExchangeAsset> assets;

  ExchangeAssetsLoaded(this.assets);

  @override
  List<Object?> get props => [assets];
}

class ExchangeAssetsError extends ExchangeAssetsState {
  final String message;

  ExchangeAssetsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExchangeAssetsEmpty extends ExchangeAssetsState {}
