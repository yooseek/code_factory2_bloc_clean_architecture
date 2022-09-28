import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_detail_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/repository/restaurant_repository.dart';

import '../../../../core/domain/use_case.dart';

class GetRestaurantDetail implements UseCase<RestaurantDetailModel, String> {
  final RestaurantRepository repository;

  const GetRestaurantDetail({
    required this.repository,
  });

  @override
  Future<RestaurantDetailModel> call(String id) async {
    return await repository.getRestaurantDetail(id: id);
  }
}
