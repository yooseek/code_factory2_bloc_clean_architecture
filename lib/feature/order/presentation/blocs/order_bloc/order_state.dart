part of 'order_bloc.dart';

class OrderState extends Equatable {
  final ResponseDto<OrderModel>? orderList;
  final RequestStatus requestStatus;

  const OrderState({
    required this.orderList,
    this.requestStatus = RequestStatus.initial,
  });

  factory OrderState.initial() {
    return const OrderState(orderList: null);
  }

  OrderState copyWith({
    ResponseDto<OrderModel>? orderList,
    RequestStatus? requestStatus,
  }) {
    return OrderState(
      orderList: orderList ?? this.orderList,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }

  @override
  List<Object?> get props => [orderList, requestStatus];

}
