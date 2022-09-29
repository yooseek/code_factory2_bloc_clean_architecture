import 'package:code_factory2_bloc_clean_architecture/core/configs/color_const.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/order_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/presentation/blocs/order_bloc/order_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/presentation/widgets/order_card.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
      context.read<OrderBloc>().add(const GetOrderListEvent(fetchMore: true));
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
    return BlocConsumer<OrderBloc,OrderState>(
      listener: (context, state) {
        if(state.requestStatus == RequestStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('에러 발생')),
          );
        }
      },
      builder: (context, state) {
        final orderModel = state.orderList;
        if(orderModel is !ResponseDto<OrderModel>){
          return Container();
        }

        final model = orderModel.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<OrderBloc>().add(const GetOrderListEvent(forceRefetch: true));
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller,
              itemBuilder: (context, index) {
                if (index == orderModel.data.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: state.requestStatus == RequestStatus.fetchMore
                          ? CircularProgressIndicator()
                          : Text('마지막 데이터입니다.'),
                    ),
                  );
                }
                return OrderCard.fromModel(model: model[index]);
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
