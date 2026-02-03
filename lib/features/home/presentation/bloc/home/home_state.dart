part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {}

final class HomeStateInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

final class HomeStateLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

final class HomeStateLoaded extends HomeState {
  final MobileAppSalesDashBoardHome? homeData;
  HomeStateLoaded({required this.homeData});
  @override
  List<Object?> get props => [homeData];
}

final class HomeStateError extends HomeState {
  final String message;

  HomeStateError({this.message = 'An error occurred'});

  @override
  List<Object?> get props => [message];
}
