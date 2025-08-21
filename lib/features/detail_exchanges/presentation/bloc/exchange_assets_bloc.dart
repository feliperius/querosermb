import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_exchange_assets.dart';
import 'exchange_assets_event.dart';
import 'exchange_assets_state.dart';

class ExchangeAssetsBloc extends Bloc<ExchangeAssetsEvent, ExchangeAssetsState> {
  final GetExchangeAssets getExchangeAssets;

  ExchangeAssetsBloc({
    required this.getExchangeAssets,
  }) : super(ExchangeAssetsInitial()) {
    on<LoadExchangeAssets>(_onLoadExchangeAssets);
    on<RefreshExchangeAssets>(_onRefreshExchangeAssets);
  }

  Future<void> _onLoadExchangeAssets(
    LoadExchangeAssets event,
    Emitter<ExchangeAssetsState> emit,
  ) async {
    emit(ExchangeAssetsLoading());
    
    try {
      final assets = await getExchangeAssets(event.exchangeId);
      
      if (assets.isEmpty) {
        emit(ExchangeAssetsEmpty());
      } else {
        emit(ExchangeAssetsLoaded(assets));
      }
    } catch (e) {
      emit(ExchangeAssetsError(e.toString()));
    }
  }

  Future<void> _onRefreshExchangeAssets(
    RefreshExchangeAssets event,
    Emitter<ExchangeAssetsState> emit,
  ) async {
    try {
      final assets = await getExchangeAssets(event.exchangeId);
      
      if (assets.isEmpty) {
        emit(ExchangeAssetsEmpty());
      } else {
        emit(ExchangeAssetsLoaded(assets));
      }
    } catch (e) {
      emit(ExchangeAssetsError(e.toString()));
    }
  }
}
