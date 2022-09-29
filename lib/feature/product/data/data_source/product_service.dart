import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/entities/product_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part 'product_service.g.dart';

// http://$ip/product
@RestApi()
abstract class ProductService{
  factory ProductService(Dio dio, {String baseUrl}) = _ProductService;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<ResponseDto<ProductModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
