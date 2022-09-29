import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/core/error/http_error.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/data/data_source/product_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/entities/product_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/repository/product_repository.dart';
import 'package:dio/dio.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductService productService;

  const ProductRepositoryImpl({
    required this.productService,
  });

  @override
  Future<ResponseDto<ProductModel>> paginate({PaginationParams? paginationParams = const PaginationParams()}) async {
    try{
      // if(await networkInfo.isConnected){
      //   //인터넷이 있으면 리모트 데이터 소스를
      // }else {
      //   //인터넷이 없으면 로컬 데이터 소스를
      // }

      // 지금은 걍 외부에서 다 불러옴
      return await productService.paginate(paginationParams: paginationParams);
    }on DioError catch(e) {
      // throw ServerException();
      throw httpErrorHandler(e);
    }
  }

}