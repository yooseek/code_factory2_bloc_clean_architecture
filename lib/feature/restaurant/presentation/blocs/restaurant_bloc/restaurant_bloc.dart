import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/use_case/get_restaurant_detail.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/use_case/get_restaurant_list.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

import '../../../domain/entities/restaurant_detail_model.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurantList getRestaurantList;
  final GetRestaurantDetail getRestaurantDetail;

  RestaurantBloc({
    required this.getRestaurantList,
    required this.getRestaurantDetail,
  }) : super(RestaurantState.initial()) {
    on<GetRestaurantListEvent>(_getRestaurantListEvent,transformer: droppable());
    on<GetRestaurantDetailEvent>(_getRestaurantDetailEvent,transformer: droppable());
  }

  Future<void> _getRestaurantListEvent(
      GetRestaurantListEvent event, emit) async {
    try {
      // 5가지 상태
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫 번째 페이지부터 다시 데이터를 가져올 때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 떄

      // 조건
      // 1) meta 안에 hasMore 가 false 일 때 (다음 데이터가 없을 때)
      if (state.requestStatus == RequestStatus.loaded && !event.forceRefetch) {
        if (!state.restaurantList!.meta.hasMore) {
          return;
        }
      }

      // 2) 로딩 중일 때 + fetchMore가 true일 때
      // 로딩 중이면서 새로운 데이터를 추가로 또 요청하면 더 이상 진행할 필요없음
      if (event.fetchMore && state.requestStatus == RequestStatus.loading) {
        return;
      }

      PaginationParams paginationParams =
          PaginationParams(count: event.fetchCount);

      // 3) 캐시가 되어진 후 데이터를 더 불러올 때 - fetchMore : true
      if (event.fetchMore) {
        emit(state.copyWith(requestStatus: RequestStatus.fetchMore));

        paginationParams = paginationParams.copyWith(
          after: state.restaurantList!.data.last.id,
        );
      }
      // 4) 데이터를 처음부터 가져오는 상황
      else {
        // 만약 데이터가 있는 상황이라면 기존 데이터를 보존한채로 요청을 진행 - 새로고침
        if (state.requestStatus == RequestStatus.loaded &&
            !event.forceRefetch) {
          emit(state.copyWith(requestStatus: RequestStatus.reFetch));
        } else {
          emit(state.copyWith(requestStatus: RequestStatus.loading));
        }
      }

      // 데이터 요청
      final response = await getRestaurantList.call(paginationParams);

      // 데이터 요청 완료된 후처리
      if (state.requestStatus == RequestStatus.fetchMore) {
        emit(state.copyWith(
            restaurantList: state.restaurantList!.copyWith(
                    data: [...state.restaurantList!.data, ...response.data])
                as ResponseDto<RestaurantModel>,requestStatus: RequestStatus.loaded));
      } else {
        emit(state.copyWith(restaurantList: response, requestStatus: RequestStatus.loaded));
      }
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      emit(state.copyWith(requestStatus: RequestStatus.error));
    }
  }

  Future<void> _getRestaurantDetailEvent(GetRestaurantDetailEvent event, emit) async {
    final id = event.id;
    final response = state.requestStatus;

    // 데이터가 하나도 없는 상태라면 - (CursorPagination) 이 아니라면
    if (response != RequestStatus.loaded) {
      add(const GetRestaurantListEvent());
    }

    // 다시 paginate를 했는데도 state가 CursorPaginantion 이 아니라면
    if (response != RequestStatus.loaded) {
      return;
    }

    final pState = state.restaurantList;

    final RestaurantDetailModel res =
    await getRestaurantDetail.call(id);

    // restaurantModel은 없는데 restaurantDetailModel을 가져왔을 때
    // 그냥 뒤에 추가
    if (pState!.data.where((element) => element.id == id).isEmpty) {
      emit(state.copyWith(restaurantList: pState.copyWith(data: [
        ...pState.data,
        res,
      ]) as ResponseDto<RestaurantModel>));
    } else {
      // 현재 pState는 restaurantModel,
      // 디테일을 한 번 불러오면 해당 restaurantModel을 restaurantDetailModel로 전환
      emit(state.copyWith(restaurantList: pState.copyWith(
        data: pState.data
            .map<RestaurantModel>(
              (e) => e.id == id ? res : e,
        )
            .toList(),
      ) as ResponseDto<RestaurantModel>));
    }
  }
}
