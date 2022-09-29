import 'package:code_factory2_bloc_clean_architecture/core/configs/color_const.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/entities/product_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/presentation/blocs/product_bloc/product_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/widgets/prodoct_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치면
    // 새로운 데이터를 추가 요청
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      context.read<ProductBloc>().add(const GetProductListEvent(fetchMore: true));
    }
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc,ProductState>(
      listener: (context, state) {
        if(state.requestStatus == RequestStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('에러 발생')),
          );
        }
      },
      builder: (context, state) {
        final productModel = state.productList;
        if(productModel is !ResponseDto<ProductModel>){
          return Container();
        }

        final model = productModel.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<ProductBloc>().add(const GetProductListEvent(forceRefetch: true));
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller,
              itemBuilder: (context, index) {
                if (index == productModel.data.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: state.requestStatus == RequestStatus.fetchMore
                          ? CircularProgressIndicator()
                          : Text('마지막 데이터입니다.'),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    context.goNamed(
                      'restaurantDetail',
                      params: {'rid': model[index].restaurant.id},
                    );
                  },
                  child: ProductCard.fromProductModel(
                    model: model[index],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    color: BODY_TEXT_COLOR,
                    thickness: 2.0,
                  ),
                );
              },
              itemCount: model.length + 1,
            ),
          ),
        );
      },
    );
  }
}
