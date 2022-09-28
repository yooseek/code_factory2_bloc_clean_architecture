part of 'restaurant_bloc.dart';

@immutable
abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class GetRestaurantListEvent extends RestaurantEvent {
  final int fetchCount;

  // true = 추가로 데이터 더 가져옴
  // false = 새로고침 (현재 상태를 덮어씌움)
  final bool fetchMore;

  // 강제로 다시 로딩하기
  // true - CursorPaginationLoading()
  final bool forceRefetch;

  const GetRestaurantListEvent({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });

  @override
  List<Object> get props => [fetchCount, fetchMore, forceRefetch];
}

class GetRestaurantDetailEvent extends RestaurantEvent {
  final String id;

  const GetRestaurantDetailEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
