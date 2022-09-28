part of 'basket_bloc.dart';

abstract class BasketEvent extends Equatable {
  const BasketEvent();
}

class AddToBasketEvent extends BasketEvent {
  final ProductModel product;

  const AddToBasketEvent({
    required this.product,
  });

  AddToBasketEvent copyWith({
    ProductModel? product,
  }) {
    return AddToBasketEvent(
      product: product ?? this.product,
    );
  }

  @override
  List<Object> get props => [product];
}

class RemoveFromBasketEvent extends BasketEvent {
  final ProductModel product;
  final bool isDelete;

  const RemoveFromBasketEvent({
    required this.product,
    this.isDelete = false,
  });

  RemoveFromBasketEvent copyWith({
    ProductModel? product,
    bool? isDelete,
  }) {
    return RemoveFromBasketEvent(
      product: product ?? this.product,
      isDelete: isDelete ?? this.isDelete,
    );
  }

  @override
  List<Object> get props => [product, isDelete];
}


class PatchBasketEvent extends BasketEvent {
  @override
  List<Object> get props => [];
}

class RemoveAllBasketEvent extends BasketEvent {
  @override
  List<Object> get props => [];
}