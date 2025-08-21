import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_exchange_assets.dart';
import '../bloc/exchange_assets_state.dart';

class ExchangeAssetsCubit extends Cubit<ExchangeAssetsState> {
  final GetExchangeAssets getExchangeAssets;

  ExchangeAssetsCubit({
    required this.getExchangeAssets,
  }) : super(ExchangeAssetsInitial());

  Future<void> loadAssets(int exchangeId) async {
    emit(ExchangeAssetsLoading());
    
    try {
      final assets = await getExchangeAssets(exchangeId);
      
      if (assets.isEmpty) {
        emit(ExchangeAssetsEmpty());
      } else {
        emit(ExchangeAssetsLoaded(assets));
      }
    } catch (e) {
      emit(ExchangeAssetsError(e.toString()));
    }
  }

  Future<void> refreshAssets(int exchangeId) async {
    try {
      final assets = await getExchangeAssets(exchangeId);
      
      if (assets.isEmpty) {
        emit(ExchangeAssetsEmpty());
      } else {
        emit(ExchangeAssetsLoaded(assets));
      }
    } catch (e) {
      emit(ExchangeAssetsError(e.toString()));
    }
  }

  void reset() {
    emit(ExchangeAssetsInitial());
  }
}
