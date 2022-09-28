part of 'basket_bloc.dart';

class BasketState extends Equatable {
  final List<BasketItemModel> basketItemList;
  final RequestStatus requestStatus;

  const BasketState({
    required this.basketItemList,
    this.requestStatus = RequestStatus.initial,
  });

  factory BasketState.initial() {
    return const BasketState(basketItemList: []);
  }

  BasketState copyWith({
    List<BasketItemModel>? basketItemList,
    RequestStatus? requestStatus,
  }) {
    return BasketState(
      basketItemList: basketItemList ?? this.basketItemList,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }

  @override
  List<Object> get props => [basketItemList, requestStatus];
}
