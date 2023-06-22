// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_list_bloc.dart';

class ProductListState extends Equatable {
  ProductListDataStatus productListDataStatus;
  ProductListState({
    required this.productListDataStatus,
  });

  ProductListState copyWith({ProductListDataStatus? newProductListDataStatus}) {
    return ProductListState(
        productListDataStatus:
            newProductListDataStatus ?? productListDataStatus);
  }

  @override
  List<Object> get props => [productListDataStatus];
}
