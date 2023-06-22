import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';
import 'package:nike_app/features/feature_prodcut/data/repository/prodcut_repository.dart';
import 'package:nike_app/features/feature_prodcut/presentation/blocs/product_list_bloc/product_list_data_status.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository productRepository;
  ProductListBloc(this.productRepository)
      : super(
            ProductListState(productListDataStatus: ProductListDataLoading())) {
    on<ProductListStarted>((event, emit) async {
      emit(state.copyWith(newProductListDataStatus: ProductListDataLoading()));

      if (event.search.isEmpty) {
        final result = await productRepository.getAll(event.sort);
        result.fold((error) {
          emit(state.copyWith(
              newProductListDataStatus: ProductListDataError(error)));
        }, (productList) {
          emit(state.copyWith(
              newProductListDataStatus: ProductListDataSuccess(
                  productList, event.sort, ProductSort.sortNameList)));
        });
      } else {
        final result = await productRepository.search(event.search);
        result.fold((error) {
          emit(state.copyWith(
              newProductListDataStatus: ProductListDataError(error)));
        }, (productList) {
          if (productList.isEmpty) {
            emit(state.copyWith(
                newProductListDataStatus: ProductListDataEmpty(
                    "محصولی با مشابه عبارت مورد جستجوی شما یافت نشد")));
          } else {
            emit(state.copyWith(
                newProductListDataStatus: ProductListDataSuccess(
                    productList, event.sort, ProductSort.sortNameList)));
          }
        });
      }
    });
  }
}
