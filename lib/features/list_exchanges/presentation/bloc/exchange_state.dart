import 'package:equatable/equatable.dart';
import '../../domain/entities/exchange.dart';

abstract class ExchangeState extends Equatable {
  const ExchangeState();

  @override
  List<Object> get props => [];
}

class ExchangeInitial extends ExchangeState {}

class ExchangeLoading extends ExchangeState {}

class ExchangeLoadingMore extends ExchangeState {
  final List<Exchange> currentExchanges;

  const ExchangeLoadingMore(this.currentExchanges);

  @override
  List<Object> get props => [currentExchanges];
}

class ExchangeLoaded extends ExchangeState {
  final List<Exchange> exchanges;
  final bool hasReachedMax;

  const ExchangeLoaded(this.exchanges, {this.hasReachedMax = false});

  @override
  List<Object> get props => [exchanges, hasReachedMax];
}

class ExchangeError extends ExchangeState {
  final String message;

  const ExchangeError(this.message);

  @override
  List<Object> get props => [message];
}

class ExchangeDetailLoaded extends ExchangeState {
  final Exchange exchange;

  const ExchangeDetailLoaded(this.exchange);

  @override
  List<Object> get props => [exchange];
}
