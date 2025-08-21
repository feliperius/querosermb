import 'package:equatable/equatable.dart';

abstract class DetailExchangeEvent extends Equatable {
  const DetailExchangeEvent();

  @override
  List<Object?> get props => [];
}

class LoadDetailExchange extends DetailExchangeEvent {
  final int id;

  const LoadDetailExchange(this.id);

  @override
  List<Object?> get props => [id];
}
