import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/order_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/entities/post_order_body.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part 'order_service.g.dart';

@RestApi()
abstract class OrderService  {
  factory OrderService(Dio dio, {String baseUrl}) = _OrderService;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<ResponseDto<OrderModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @POST('/')
  @Headers({'accessToken': 'true'})
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
