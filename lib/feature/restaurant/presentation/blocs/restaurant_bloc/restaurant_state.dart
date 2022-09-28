part of 'restaurant_bloc.dart';

enum RequestStatus {
  initial,
  loading,
  loaded,
  error,
  fetchMore,
  reFetch,
}

class RestaurantState extends Equatable {
  final ResponseDto<RestaurantModel>? restaurantList;
  final RequestStatus requestStatus;

  const RestaurantState({
    required this.restaurantList,
    this.requestStatus = RequestStatus.initial,
  });

  factory RestaurantState.initial() {
    return const RestaurantState(restaurantList: null);
  }

  RestaurantState copyWith({
    ResponseDto<RestaurantModel>? restaurantList,
    RequestStatus? requestStatus,
  }) {
    return RestaurantState(
      restaurantList: restaurantList ?? this.restaurantList,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }

  @override
  List<Object?> get props => [restaurantList, requestStatus];
}
