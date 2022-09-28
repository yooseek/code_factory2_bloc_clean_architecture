import 'package:code_factory2_bloc_clean_architecture/core/data/dto/pagination_params.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/data/data_source/rating_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/domain/entities/rating_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/domain/repository/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingService ratingService;

  const RatingRepositoryImpl({
    required this.ratingService,
  });

  @override
  Future<ResponseDto<RatingModel>> paginate({PaginationParams? paginationParams = const PaginationParams(),required String id}) async{
    return await ratingService.paginate(paginationParams: paginationParams,id: id);
  }
}