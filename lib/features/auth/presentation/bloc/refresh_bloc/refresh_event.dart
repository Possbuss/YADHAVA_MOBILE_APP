part of 'refresh_bloc.dart';

abstract class RefreshEvent extends Equatable {
  const RefreshEvent();
}
class RefreshTokenEvent extends RefreshEvent{
  final Map<String,dynamic> refreshData;

  const RefreshTokenEvent(this.refreshData);
  @override
  List<Object?> get props => [refreshData];
}