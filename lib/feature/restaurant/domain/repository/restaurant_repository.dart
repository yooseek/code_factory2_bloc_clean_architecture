import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';

import '../entities/restaurant_detail_model.dart';

abstract class RestaurantRepository {
  Future<ResponseDto<RestaurantModel>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });

  Future<RestaurantDetailModel> getRestaurantDetail({required String id});
}