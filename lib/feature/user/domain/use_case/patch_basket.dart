import 'package:code_factory2_bloc_clean_architecture/core/domain/use_case.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/basket_item_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/patch_basket_body_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/repository/user_repository.dart';

class PatchBasket implements UseCase<List<BasketItemModel>, PatchBasketBody> {
  final UserRepository userRepository;

  const PatchBasket({
    required this.userRepository,
  });

  @override
  Future<List<BasketItemModel>> call(PatchBasketBody body) async {
    final basketItemModel = await userRepository.patchBasket(body: body);

    return basketItemModel;
  }
}