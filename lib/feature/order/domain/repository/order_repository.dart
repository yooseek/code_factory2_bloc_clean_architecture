import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/order_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/post_order_body.dart';

abstract class OrderRepository {
  Future<ResponseDto<OrderModel>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });

  Future<OrderModel> postOrder({
    required PostOrderBody body,
  });
}