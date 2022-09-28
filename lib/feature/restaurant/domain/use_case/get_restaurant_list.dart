import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/core/domain/use_case.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/repository/restaurant_repository.dart';

class GetRestaurantList implements UseCase<ResponseDto<RestaurantModel>, PaginationParams> {
  final RestaurantRepository repository;

  const GetRestaurantList({
    required this.repository,
  });

  @override
  Future<ResponseDto<RestaurantModel>> call(PaginationParams? paginationParams) async {
    return await repository.paginate(paginationParams: paginationParams);
  }
}
