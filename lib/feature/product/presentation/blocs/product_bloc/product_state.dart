part of 'product_bloc.dart';

class ProductState extends Equatable {
  final ResponseDto<ProductModel>? productList;
  final RequestStatus requestStatus;

  const ProductState({
    required this.productList,
    this.requestStatus = RequestStatus.initial,
  });

  factory ProductState.initial() {
    return ProductState(productList: null);
  }

  ProductState copyWith({
    ResponseDto<ProductModel>? restaurantList,
    RequestStatus? requestStatus,
  }) {
    return ProductState(
      productList: restaurantList ?? this.productList,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }

  @override
  List<Object?> get props => [productList, requestStatus];
}
