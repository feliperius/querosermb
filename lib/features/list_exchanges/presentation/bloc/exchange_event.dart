import 'package:equatable/equatable.dart';

abstract class ExchangeEvent extends Equatable {
  const ExchangeEvent();

  @override
  List<Object> get props => [];
}

class LoadExchanges extends ExchangeEvent {
  final bool refresh;
  final int limit;
  
  const LoadExchanges({this.refresh = false, this.limit = 10});
  
  @override
  List<Object> get props => [refresh, limit];
}

class LoadMoreExchanges extends ExchangeEvent {
  final int limit;
  
  const LoadMoreExchanges({this.limit = 10});
  
  @override
  List<Object> get props => [limit];
}

class LoadExchangeById extends ExchangeEvent {
  final int id;

  const LoadExchangeById(this.id);

  @override
  List<Object> get props => [id];
}
