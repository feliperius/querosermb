import 'package:equatable/equatable.dart';

abstract class ExchangeEvent extends Equatable {
  const ExchangeEvent();

  @override
  List<Object> get props => [];
}

class LoadExchanges extends ExchangeEvent {}

class LoadExchangeById extends ExchangeEvent {
  final int id;

  const LoadExchangeById(this.id);

  @override
  List<Object> get props => [id];
}
