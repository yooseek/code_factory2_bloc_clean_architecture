part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class GetOrderListEvent extends OrderEvent {
  final int fetchCount;

  // true = 추가로 데이터 더 가져옴
  // false = 새로고침 (현재 상태를 덮어씌움)
  final bool fetchMore;

  // 강제로 다시 로딩하기
  // true - CursorPaginationLoading()
  final bool forceRefetch;

  const GetOrderListEvent({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });

  @override
  List<Object> get props => [fetchCount, fetchMore, forceRefetch];
}

class PostOrderEvent extends OrderEvent {
  @override
  List<Object> get props => [];
}