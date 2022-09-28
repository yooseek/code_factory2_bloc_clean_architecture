import 'package:code_factory2_bloc_clean_architecture/core/configs/color_const.dart';
import 'package:code_factory2_bloc_clean_architecture/core/presentation/widgets/default_layout.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/widgets/prodoct_card.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/basket_bloc/basket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: PRIMARY_COLOR,
                      ),
                      onPressed: () async {
                        // final isSuccess =
                        // await ref.read(orderProvider.notifier).postOrder();
                        //
                        // if (isSuccess) {
                        //   print('성공했다.');
                        //   context.goNamed(OrderDoneScreen.routeName);
                        // } else {
                        //   print('실패했다.');
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text('결제 실패'),
                        //     ),
                        //   );
                        // }
                      },
                      child: Text(
                        '결제하기',
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
