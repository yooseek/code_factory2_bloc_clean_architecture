import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_detail_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part 'restaurant_service.g.dart';

@RestApi()
abstract class RestaurantService{
  // http://127.0.0.1:3000/restaurant
  factory RestaurantService(Dio dio, {String baseUrl}) =
  _RestaurantService;

  // http://127.0.0.1:3000/restaurant/
  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<ResponseDto<RestaurantModel>> paginate({
    // retrofit 에서의 쿼리 추가
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // http://127.0.0.1:3000/restaurant/{id}
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String id,
  });
}
