import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/core/domain/use_case.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/entities/product_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/repository/product_repository.dart';

class GetProductList extends UseCase<ResponseDto<ProductModel>,PaginationParams> {
  final ProductRepository productRepository;

  GetProductList({
    required this.productRepository,
  });

  @override
  Future<ResponseDto<ProductModel>> call(PaginationParams params) async {
    return await productRepository.paginate(paginationParams: params);
  }
}