import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/domain/entities/rating_model.dart';

abstract class RatingRepository {
  Future<ResponseDto<RatingModel>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
    required String id,
  });
}