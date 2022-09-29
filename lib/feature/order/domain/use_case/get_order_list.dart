import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/order_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/repository/order_repository.dart';

import '../../../../core/domain/use_case.dart';

class GetOrderList extends UseCase<ResponseDto<OrderModel>,PaginationParams> {
  final OrderRepository orderRepository;

  GetOrderList({
    required this.orderRepository,
  });

  @override
  Future<ResponseDto<OrderModel>> call(PaginationParams? paginationParams) async {
    return await orderRepository.paginate(paginationParams: paginationParams);
  }
}