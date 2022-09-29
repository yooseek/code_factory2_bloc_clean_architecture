import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/entities/product_model.dart';

abstract class ProductRepository {
  Future<ResponseDto<ProductModel>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}