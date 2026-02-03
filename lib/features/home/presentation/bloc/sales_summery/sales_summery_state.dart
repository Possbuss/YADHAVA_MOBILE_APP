part of 'sales_summery_bloc.dart';

@immutable
sealed class SalesSummeryState extends Equatable{}

final class SalesSummeryInitial extends SalesSummeryState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class SalesSummeryLoading extends SalesSummeryState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class SalesSummeryLoaded extends SalesSummeryState {
  final List<SalesSummery> salesList;
 SalesSummeryLoaded({required this.salesList});
  @override
  // TODO: implement props
  List<Object?> get props => [salesList];
}

final class SalesSummeryError extends SalesSummeryState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
