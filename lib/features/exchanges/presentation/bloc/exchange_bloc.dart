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
    on<LoadExchangeById>(_onLoadExchangeById);
  }

  Future<void> _onLoadExchanges(
    LoadExchanges event,
    Emitter<ExchangeState> emit,
  ) async {
    emit(ExchangeLoading());
    try {
      final exchanges = await getExchanges();
      emit(ExchangeLoaded(exchanges));
    } catch (e) {
      emit(ExchangeError(e.toString()));
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
