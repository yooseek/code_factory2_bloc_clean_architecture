import 'package:code_factory2_bloc_clean_architecture/core/domain/use_case.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/order_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/post_order_body.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/repository/order_repository.dart';

class PostOrder extends UseCase<OrderModel,PostOrderBody> {
  final OrderRepository orderRepository;

  PostOrder({
    required this.orderRepository,
  });

  @override
  Future<OrderModel> call(PostOrderBody body) async {
    return await orderRepository.postOrder(body: body);
  }
}