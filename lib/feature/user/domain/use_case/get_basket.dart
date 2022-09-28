import 'package:code_factory2_bloc_clean_architecture/core/domain/use_case.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/basket_item_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/repository/user_repository.dart';

class GetBasket implements UseCase<List<BasketItemModel>, NoParams> {
  final UserRepository userRepository;

  const GetBasket({
    required this.userRepository,
  });

  @override
  Future<List<BasketItemModel>> call(NoParams? noParams) async {
    final basketItemModel = await userRepository.getBasket();

    return basketItemModel;
  }
}