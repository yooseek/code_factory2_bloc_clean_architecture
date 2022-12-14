import 'package:badges/badges.dart';
import 'package:code_factory2_bloc_clean_architecture/core/configs/color_const.dart';
import 'package:code_factory2_bloc_clean_architecture/core/presentation/widgets/default_layout.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/entities/product_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/domain/entities/rating_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/presentation/bloc/rating_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/presentation/widgets/rating_card.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/screens/basket_screen.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/widgets/prodoct_card.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/widgets/restaurant_card.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/basket_bloc/basket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';

import '../../domain/entities/restaurant_detail_model.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String id;

  const RestaurantDetailScreen({required this.id,Key? key}) : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<RestaurantBloc>().add(GetRestaurantDetailEvent(id: widget.id));
    context.read<RatingBloc>().add(GetRatingListEvent(id: widget.id));

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // ?????? ????????? ?????? ???????????? ?????? ??? ?????? ?????????
    // ????????? ???????????? ?????? ??????
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      context.read<RatingBloc>().add(GetRatingListEvent(fetchMore: true,id: widget.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RestaurantBloc>().state;

    final basketState = context.watch<BasketBloc>().state;

    if(state.requestStatus != RequestStatus.loaded){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final data = state.restaurantList!.data.firstWhereOrNull((element) => element.id == widget.id);
    if(data == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return DefaultLayout(
      title: data.name,
      // floatingActionButton ??? ?????? ????????????
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('basket');
        },
        backgroundColor: PRIMARY_COLOR,
        child: Badge(
          // ?????? ????????? ???????????????
          showBadge: basketState.basketItemList.isNotEmpty,
          // ?????? ????????? ??????
          badgeContent: Text(
            basketState.basketItemList
                .fold<int>(0,
                    (previousValue, element) => previousValue + element.count)
                .toString(),
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 10.0,
            ),
          ),
          // ?????? ??????
          position: const BadgePosition(top: - 16,end: -16),
          badgeColor: Colors.white,
          child: const Icon(Icons.shopping_basket_outlined),
        ),
      ),
      child:
      // ??? ?????? ???????????? ???????????? ?????? ????????? ??????????????? ???????????? ?????? ???
      CustomScrollView(
        controller: controller,
        slivers: [
          // ?????? ????????? sliver ????????? ?????? ???
          SliverToBoxAdapter(
            child: RestaurantCard.fromModel(model: data, isDetail: true),
          ),

          // ????????? ????????? ?????? ?????? ???
          if (data is! RestaurantDetailModel) renderLoading(),
          if (data is RestaurantDetailModel)
          // ?????? ????????? sliver ????????? ?????? ??? - Label
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '??????',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          if (data is RestaurantDetailModel)
          // List ??? ????????? sliver ????????? ?????? ???
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final model = data.products[index];

                    return InkWell(
                      onTap: () {
                        context.read<BasketBloc>().add(AddToBasketEvent(product: ProductModel(
                            id: model.id,
                            name: model.name,
                            detail: model.detail,
                            imgUrl: model.imgUrl,
                            price: model.price,
                            restaurant: data),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ProductCard.fromRestaurantProductModel(
                            model: model),
                      ),
                    );
                  },
                  childCount: data.products.length,
                ),
              ),
            ),
          RatingList(),
        ],
      ),
    );
  }

  // ?????? ?????? ???????????? ???????????? - skeletons
  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            4,
                (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SkeletonParagraph(
                style: const SkeletonParagraphStyle(
                  // ??? ??? ????????? ???????????????
                  lines: 5,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
    super.dispose();
  }
}

class RatingList extends StatelessWidget {
  const RatingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ratingState = context.watch<RatingBloc>().state;

    if(ratingState.requestStatus == RequestStatus.loaded || ratingState.requestStatus == RequestStatus.fetchMore){
      final models = ratingState.ratingList!.data;

      return SliverPadding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: RatingCard.fromModel(model: models[index]));
            },
            childCount: models.length,
          ),
        ),
      );
    }

    return SliverPadding(padding: EdgeInsets.only(bottom: 8.0),sliver: SliverToBoxAdapter(child: Container()),);
  }
}
