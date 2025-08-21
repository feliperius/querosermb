import 'package:equatable/equatable.dart';
import '../../../list_exchanges/domain/entities/exchange.dart';

abstract class DetailExchangeState extends Equatable {
  const DetailExchangeState();

  @override
  List<Object?> get props => [];
}

class DetailExchangeInitial extends DetailExchangeState {}
class DetailExchangeLoading extends DetailExchangeState {}
class DetailExchangeError extends DetailExchangeState {
  final String message;
  const DetailExchangeError(this.message);

  @override
  List<Object?> get props => [message];
}

class DetailExchangeLoaded extends DetailExchangeState {
  final Exchange exchange;
  const DetailExchangeLoaded(this.exchange);

  @override
  List<Object?> get props => [exchange];
}
