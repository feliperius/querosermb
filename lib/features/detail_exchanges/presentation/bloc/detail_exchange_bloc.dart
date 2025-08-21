import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../list_exchanges/domain/usecases/get_exchange_by_id.dart' as list_usecase;
import 'detail_exchange_event.dart';
import 'detail_exchange_state.dart';

class DetailExchangeBloc extends Bloc<DetailExchangeEvent, DetailExchangeState> {
  final list_usecase.GetExchangeById getExchangeById;

  DetailExchangeBloc({required this.getExchangeById}) : super(DetailExchangeInitial()) {
    on<LoadDetailExchange>(_onLoadDetail);
  }

  Future<void> _onLoadDetail(LoadDetailExchange event, Emitter<DetailExchangeState> emit) async {
    emit(DetailExchangeLoading());
    try {
      final exchange = await getExchangeById(event.id);
      emit(DetailExchangeLoaded(exchange));
    } catch (e) {
      emit(DetailExchangeError(e.toString()));
    }
  }
}
