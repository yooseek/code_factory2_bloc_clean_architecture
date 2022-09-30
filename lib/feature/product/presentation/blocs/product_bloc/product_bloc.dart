import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/entities/product_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/use_case/get_product_list.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductList getProductList;

  ProductBloc({
    required this.getProductList,
  }) : super(ProductState.initial()) {
    on<GetProductListEvent>(_getProductListEvent,transformer: droppable());
  }

  Future<void> _getProductListEvent(GetProductListEvent event, emit) async {
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
        if (!state.productList!.meta.hasMore) {
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
          after: state.productList!.data.last.id,
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
      final response = await getProductList.call(paginationParams);

      // 데이터 요청 완료된 후처리
      if (state.requestStatus == RequestStatus.fetchMore) {
        emit(state.copyWith(
            restaurantList: state.productList!.copyWith(
                    data: [...state.productList!.data, ...response.data])
                as ResponseDto<ProductModel>,
            requestStatus: RequestStatus.loaded));
      } else {
        emit(state.copyWith(
            restaurantList: response, requestStatus: RequestStatus.loaded));
      }
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      emit(state.copyWith(requestStatus: RequestStatus.error));
    }
  }
}
