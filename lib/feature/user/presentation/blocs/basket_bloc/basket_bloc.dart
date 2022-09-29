import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/entities/product_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/basket_item_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/patch_basket_body_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/use_case/get_basket.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/use_case/patch_basket.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

part 'basket_event.dart';
part 'basket_state.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  final GetBasket getBasket;
  final PatchBasket patchBasket;

  BasketBloc({
    required this.getBasket,
    required this.patchBasket,
  }) : super(BasketState.initial()) {
    on<AddToBasketEvent>(_addToBasketEvent);
    on<RemoveFromBasketEvent>(_removeFromBasketEvent);
    on<PatchBasketEvent>(_patchBasketEvent, transformer: droppable());
    on<RemoveAllBasketEvent>(_removeAllBasketEvent);
  }

  Future<void> _addToBasketEvent(AddToBasketEvent event, emit) async {
    final product = event.product;
    // 요청을 먼저 보내고, 응답이 오면, 캐시를 업데이트
    // Optimistic Response (긍정적 응답) - 응답의 성공을 가정하고 상태를 먼저 업데이트함

    // import collection
    final exists = state.basketItemList
            .firstWhereOrNull((element) => element.product.id == product.id) !=
        null;

    if (exists) {
      // 장바구니에 해당 상품이 있을 때
      emit(state.copyWith(
          basketItemList: state.basketItemList
              .map(
                (e) => e.product.id == product.id
                    ? e.copyWith(count: e.count + 1)
                    : e,
              )
              .toList()));
    } else {
      // 장바구니에 해당 상품이 없을 때
      emit(state.copyWith(basketItemList: [
        ...state.basketItemList,
        BasketItemModel(product: product, count: 1)
      ]));
    }

    add(PatchBasketEvent());
  }

  Future<void> _removeFromBasketEvent(RemoveFromBasketEvent event, emit) async {
    final product = event.product;
    final exists = state.basketItemList
            .firstWhereOrNull((element) => element.product.id == product.id) !=
        null;
    // 장바구나에 해당 상품이 없을 때 - 뭔가 오류
    if (!exists) {
      return;
    }

    // 장바구니에 해당 상품이 있을 때
    final existingProduct = state.basketItemList
        .firstWhere((element) => element.product.id == product.id);

    if (existingProduct.count == 1 || event.isDelete) {
      // 해당 상품의 카운트가 1일 때는 상품 삭제

      emit(state.copyWith(
          basketItemList: state.basketItemList
              .where((element) => element.product.id != product.id)
              .toList()));
    } else {
      // 해당 상품의 카운트가 1이상 일 때는 카운트 다운

      emit(state.copyWith(
          basketItemList: state.basketItemList
              .map(
                (e) => e.product.id == product.id
                    ? e.copyWith(count: e.count - 1)
                    : e,
              )
              .toList()));
    }

    add(PatchBasketEvent());
  }

  Future<void> _patchBasketEvent(PatchBasketEvent event, emit) async {
    await patchBasket.call(PatchBasketBody(
      basket: state.basketItemList
          .map(
            (e) =>
                PatchBasketBodyBasket(productId: e.product.id, count: e.count),
          )
          .toList(),
    ));
  }

  Future<void> _removeAllBasketEvent(RemoveAllBasketEvent event, emit) async {
    emit(state.copyWith(basketItemList: []));

    await patchBasket.call(const PatchBasketBody(basket: []));
  }
}
