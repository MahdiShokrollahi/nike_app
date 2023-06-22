import 'package:equatable/equatable.dart';

abstract class HomeDataStatus extends Equatable {}

class HomeDataLoading extends HomeDataStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HomeDataResponse extends HomeDataStatus {
  final dynamic banners;
  final dynamic latestProducts;
  final dynamic popularProducts;

  HomeDataResponse(this.banners, this.latestProducts, this.popularProducts);

  @override
  // TODO: implement props
  List<Object?> get props => [banners, latestProducts, popularProducts];
}
