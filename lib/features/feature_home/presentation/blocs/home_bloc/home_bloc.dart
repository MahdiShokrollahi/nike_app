import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';
import 'package:nike_app/features/feature_home/data/repository/banner_repository.dart';
import 'package:nike_app/features/feature_prodcut/data/repository/prodcut_repository.dart';
import 'package:nike_app/features/feature_home/presentation/blocs/home_bloc/home_data_status.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;
  HomeBloc(this.bannerRepository, this.productRepository)
      : super(HomeState(homeDataStatus: HomeDataLoading())) {
    on<HomeStarted>((event, emit) async {
      emit(state.copyWith(newHomeStatus: HomeDataLoading()));
      var banners = await bannerRepository.getAll();
      var latestProducts = await productRepository.getAll(ProductSort.latest);
      var popularProducts = await productRepository.getAll(ProductSort.popular);
      emit(state.copyWith(
          newHomeStatus:
              HomeDataResponse(banners, latestProducts, popularProducts)));
    });
  }
}
