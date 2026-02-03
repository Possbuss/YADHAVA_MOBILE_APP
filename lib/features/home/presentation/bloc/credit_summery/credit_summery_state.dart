// import 'package:Yadhava/features/home/data/credit_summery.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
part of 'credit_summery_bloc.dart';

@immutable
sealed class CreditSummeryState extends Equatable {}

final class CreditSummeryInitial extends CreditSummeryState {
  @override
  List<Object?> get props => [];
}

final class CreditSummeryLoading extends CreditSummeryState {
  @override
  List<Object?> get props => [];
}

final class CreditSummeryLoaded extends CreditSummeryState {
  final List<CreditSummery> creditSummeryList;
  CreditSummeryLoaded({required this.creditSummeryList});
  @override
  List<Object?> get props => [creditSummeryList];
}

final class CreditSummeryError extends CreditSummeryState {
  final String message;

  CreditSummeryError({this.message = 'An error occurred'});

  @override
  List<Object?> get props => [message];
}
