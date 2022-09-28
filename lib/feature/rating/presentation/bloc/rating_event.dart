part of 'rating_bloc.dart';

@immutable
abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object> get props => [];
}

class GetRatingListEvent extends RatingEvent {
  final int fetchCount;

  // true = 추가로 데이터 더 가져옴
  // false = 새로고침 (현재 상태를 덮어씌움)
  final bool fetchMore;

  // 강제로 다시 로딩하기
  // true - CursorPaginationLoading()
  final bool forceRefetch;

  final String id;

  const GetRatingListEvent({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
    required this.id,
  });

  GetRatingListEvent copyWith({
    int? fetchCount,
    bool? fetchMore,
    bool? forceRefetch,
    String? id,
  }) {
    return GetRatingListEvent(
      fetchCount: fetchCount ?? this.fetchCount,
      fetchMore: fetchMore ?? this.fetchMore,
      forceRefetch: forceRefetch ?? this.forceRefetch,
      id: id ?? this.id,
    );
  }

  @override
  List<Object> get props => [fetchCount, fetchMore, forceRefetch,id];

}