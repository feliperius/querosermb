import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_exchanges.dart';
import '../../domain/usecases/get_exchange_by_id.dart';
import 'exchange_event.dart';
import 'exchange_state.dart';

class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  final GetExchanges getExchanges;
  final GetExchangeById getExchangeById;

  ExchangeBloc({
    required this.getExchanges,
    required this.getExchangeById,
  }) : super(ExchangeInitial()) {
    on<LoadExchanges>(_onLoadExchanges);
    on<LoadMoreExchanges>(_onLoadMoreExchanges);
    on<LoadExchangeById>(_onLoadExchangeById);
  }

  Future<void> _onLoadExchanges(
    LoadExchanges event,
    Emitter<ExchangeState> emit,
  ) async {
    emit(ExchangeLoading());
    try {
      final exchanges = await getExchanges(limit: event.limit, start: 1);
      emit(ExchangeLoaded(exchanges, hasReachedMax: exchanges.length < event.limit));
    } catch (e) {
      emit(ExchangeError(e.toString()));
    }
  }

  Future<void> _onLoadMoreExchanges(
    LoadMoreExchanges event,
    Emitter<ExchangeState> emit,
  ) async {
    final currentState = state;
    if (currentState is ExchangeLoaded) {
      if (currentState.hasReachedMax) return;
      
      emit(ExchangeLoadingMore(currentState.exchanges));
      
      try {
        final newExchanges = await getExchanges(
          limit: event.limit,
          start: currentState.exchanges.length + 1,
        );
        
        final allExchanges = currentState.exchanges + newExchanges;
        emit(ExchangeLoaded(
          allExchanges, 
          hasReachedMax: newExchanges.length < event.limit,
        ));
      } catch (e) {
        emit(ExchangeError(e.toString()));
      }
    }
  }

  Future<void> _onLoadExchangeById(
    LoadExchangeById event,
    Emitter<ExchangeState> emit,
  ) async {
    emit(ExchangeLoading());
    try {
      final exchange = await getExchangeById(event.id);
      emit(ExchangeLoaded([exchange]));
    } catch (e) {
      emit(ExchangeError(e.toString()));
    }
  }
}
