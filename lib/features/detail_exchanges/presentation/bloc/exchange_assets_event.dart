abstract class ExchangeAssetsEvent {}

class LoadExchangeAssets extends ExchangeAssetsEvent {
  final int exchangeId;
  
  LoadExchangeAssets(this.exchangeId);
}

class RefreshExchangeAssets extends ExchangeAssetsEvent {
  final int exchangeId;
  
  RefreshExchangeAssets(this.exchangeId);
}
