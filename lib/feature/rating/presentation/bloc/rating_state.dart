part of 'rating_bloc.dart';

class RatingState extends Equatable {
  final ResponseDto<RatingModel>? ratingList;
  final RequestStatus requestStatus;

  const RatingState({
    required this.ratingList,
    this.requestStatus = RequestStatus.initial,
  });

  factory RatingState.initial() {
    return const RatingState(ratingList: null);
  }

  RatingState copyWith({
    ResponseDto<RatingModel>? ratingList,
    RequestStatus? requestStatus,
  }) {
    return RatingState(
      ratingList: ratingList ?? this.ratingList,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }

  @override
  List<Object?> get props => [ratingList, requestStatus];
}
