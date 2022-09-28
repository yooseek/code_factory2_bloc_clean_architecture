import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/domain/entities/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part 'rating_service.g.dart';

// http://ip/restaurant/:rid/rating
@RestApi()
abstract class RatingService {
  factory RatingService(Dio dio, {String baseUrl}) = _RatingService;

  @GET('/{id}/rating')
  @Headers({'accessToken': 'true'})
  Future<ResponseDto<RatingModel>> paginate({
    // retrofit 에서의 쿼리 추가
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
    @Path('id') required String id,
  });
}
