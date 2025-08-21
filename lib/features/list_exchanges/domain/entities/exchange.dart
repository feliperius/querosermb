import 'package:equatable/equatable.dart';

class Exchange extends Equatable {
  final int id;
  final String name;
  final String? logo;
  final double? spotVolumeUsd;
  final String? dateLaunched;
  final String? description;
  final String? website;
  final double? makerFee;
  final double? takerFee;
  final List<Currency> currencies;

  const Exchange({
    required this.id,
    required this.name,
    this.logo,
    this.spotVolumeUsd,
    this.dateLaunched,
    this.description,
    this.website,
    this.makerFee,
    this.takerFee,
    this.currencies = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        logo,
        spotVolumeUsd,
        dateLaunched,
        description,
        website,
        makerFee,
        takerFee,
        currencies,
      ];
}

class Currency extends Equatable {
  final String name;
  final double? priceUsd;

  const Currency({
    required this.name,
    this.priceUsd,
  });

  @override
  List<Object?> get props => [name, priceUsd];
}
