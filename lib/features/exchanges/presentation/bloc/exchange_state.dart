import 'package:equatable/equatable.dart';
import '../../domain/entities/exchange.dart';

abstract class ExchangeState extends Equatable {
  const ExchangeState();

  @override
  List<Object> get props => [];
}

class ExchangeInitial extends ExchangeState {}

class ExchangeLoading extends ExchangeState {}

class ExchangeLoaded extends ExchangeState {
  final List<Exchange> exchanges;

  const ExchangeLoaded(this.exchanges);

  @override
  List<Object> get props => [exchanges];
}

class ExchangeError extends ExchangeState {
  final String message;

  const ExchangeError(this.message);

  @override
  List<Object> get props => [message];
}
