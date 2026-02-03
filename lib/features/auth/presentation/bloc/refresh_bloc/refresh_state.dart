part of 'refresh_bloc.dart';

abstract class RefreshState extends Equatable {
  const RefreshState();
}

class RefreshInitial extends RefreshState {
  @override
  List<Object> get props => [];
}

class RefreshLoaded extends RefreshState {
  final dynamic response;
  const RefreshLoaded(this.response);
  @override
  List<Object> get props => [response];
}

class RefreshLoading extends RefreshState {
  @override
  List<Object> get props => [];
}

class RefreshError extends RefreshState {
  final String message;
  const RefreshError(this.message);
  @override
  List<Object> get props => [message];
}
