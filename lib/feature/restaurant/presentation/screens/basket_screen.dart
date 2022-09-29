import 'package:code_factory2_bloc_clean_architecture/core/configs/color_const.dart';
import 'package:code_factory2_bloc_clean_architecture/core/presentation/widgets/default_layout.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/presentation/blocs/order_bloc/order_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/widgets/prodoct_card.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/basket_bloc/basket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final basket = context.watch<BasketBloc>().state;

    if (basket.basketItemList.isEmpty) {
      return const DefaultLayout(
        title: '장바구니',
        child: Center(
          child: Text('장바구니가 비어있습니다.'),
        ),
      );
    }

    final deliveryFee = basket.basketItemList[0].product.restaurant.deliveryFee;
    final productTotal =
    basket.basketItemList.fold<int>(0, (p, e) => p + (e.product.price * e.count));

    return DefaultLayout(
      title: '장바구니',
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 32.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    final model = basket.basketItemList[index];

                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        context.read<BasketBloc>().add(AddToBasketEvent(product: model.product));
                      },
                      onSubtract: () {
                        context.read<BasketBloc>().add(RemoveFromBasketEvent(product: model.product));
                      },
                    );
                  },
                  itemCount: basket.basketItemList.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '장바구니 금액',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      Text(
                        '₩ ${productTotal.toString()}',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '배달비',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      Text(
                        '₩ ${deliveryFee.toString()}',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총액',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '₩ ${(productTotal + deliveryFee).toString()}',
                      ),
                    ],
                  ),
                  const OrderButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OrderButton extends StatelessWidget {
  const OrderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderStatus = context.select<OrderBloc,RequestStatus>((value) => value.state.requestStatus);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: PRIMARY_COLOR,
        ),
        onPressed: () async {
          context.read<OrderBloc>().add(PostOrderEvent());

          if (orderStatus != RequestStatus.error) {
            print('성공했다.');
            context.goNamed('order_done');
          } else {
            print('실패했다.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('결제 실패'),
              ),
            );
          }
        },
        child: Text(
          '결제하기',
        ),
      ),
    );
  }
}
