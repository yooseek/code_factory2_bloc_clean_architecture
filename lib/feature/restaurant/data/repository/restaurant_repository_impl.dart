import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/core/error/http_error.dart';
import 'package:code_factory2_bloc_clean_architecture/core/network/network_info.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_detail_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/data/data_source/restaurant_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  RestaurantRepositoryImpl({
    required this.restaurantService,
    required this.networkInfo,
  });

  RestaurantService restaurantService;
  NetworkInfo networkInfo;

  @override
  Future<ResponseDto<RestaurantModel>> paginate({PaginationParams? paginationParams = const PaginationParams()}) async {
    try{
      if(await networkInfo.isConnected){
        //인터넷이 있으면 리모트 데이터 소스를
      }else {
        //인터넷이 없으면 로컬 데이터 소스를
      }

      // 지금은 걍 외부에서 다 불러옴
      return await restaurantService.paginate(paginationParams: paginationParams);
    }on DioError catch(e) {
      // throw ServerException();
      throw httpErrorHandler(e);
    }
  }

  @override
  Future<RestaurantDetailModel> getRestaurantDetail({required String id}) async {
    try{
      if(await networkInfo.isConnected){
        //인터넷이 있으면 리모트 데이터 소스를
      }else {
        //인터넷이 없으면 로컬 데이터 소스를
      }

      // 지금은 걍 외부에서 다 불러옴
      return await restaurantService.getRestaurantDetail(id: id);
    }on DioError catch(e) {
      // throw ServerException();
      throw httpErrorHandler(e);
    }
  }

}