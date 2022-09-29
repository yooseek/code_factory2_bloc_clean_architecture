import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/core/error/http_error.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/data/data_source/order_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/order_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/post_order_body.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/repository/order_repository.dart';
import 'package:dio/dio.dart';

class OrderRepositoryImpl implements OrderRepository{
  final OrderService orderService;

  const OrderRepositoryImpl({
    required this.orderService,
  });

  @override
  Future<ResponseDto<OrderModel>> paginate({PaginationParams? paginationParams = const PaginationParams()}) async {
    try{
      // if(await networkInfo.isConnected){
      //   //인터넷이 있으면 리모트 데이터 소스를
      // }else {
      //   //인터넷이 없으면 로컬 데이터 소스를
      // }

      // 지금은 걍 외부에서 다 불러옴

      return await orderService.paginate(paginationParams: paginationParams);
    }on DioError catch(e) {
      // throw ServerException();
      throw httpErrorHandler(e);
    }
  }

  @override
  Future<OrderModel> postOrder({required PostOrderBody body}) async {
    try{
      // if(await networkInfo.isConnected){
      //   //인터넷이 있으면 리모트 데이터 소스를
      // }else {
      //   //인터넷이 없으면 로컬 데이터 소스를
      // }

      // 지금은 걍 외부에서 다 불러옴
      return await orderService.postOrder(body: body);
    }on DioError catch(e) {
      // throw ServerException();
      throw httpErrorHandler(e);
    }
  }
}