part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeGetEvent extends HomeEvent {
  final String date;
  final bool forceRefresh;
  const HomeGetEvent(this.date,{this.forceRefresh = false});
  @override
  List<Object> get props => [date];
}
