part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetProductListEvent extends ProductEvent {
  final int fetchCount;

  // true = 추가로 데이터 더 가져옴
  // false = 새로고침 (현재 상태를 덮어씌움)
  final bool fetchMore;

  // 강제로 다시 로딩하기
  // true - CursorPaginationLoading()
  final bool forceRefetch;

  const GetProductListEvent({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });

  @override
  List<Object> get props => [fetchCount, fetchMore, forceRefetch];
}