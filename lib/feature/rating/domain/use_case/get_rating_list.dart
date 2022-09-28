import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/core/domain/use_case.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/domain/entities/rating_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/domain/repository/rating_repository.dart';

class GetRatingList
    implements UseCase<ResponseDto<RatingModel>, PaginationParamsAndId> {
  final RatingRepository ratingRepository;

  const GetRatingList({
    required this.ratingRepository,
  });

  @override
  Future<ResponseDto<RatingModel>> call(PaginationParamsAndId paginationParamsAndId) async {
    return await ratingRepository.paginate(
        paginationParams: paginationParamsAndId.paginationParams, id: paginationParamsAndId.id);
  }
}

class PaginationParamsAndId extends PaginationParams {
  final PaginationParams paginationParams;
  final String id;

  PaginationParamsAndId({
    this.paginationParams = const PaginationParams(),
    required this.id,
  });
}