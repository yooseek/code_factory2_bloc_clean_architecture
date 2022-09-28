import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/basket_item_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/patch_basket_body_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getMe();

  Future<List<BasketItemModel>> getBasket();

  Future<List<BasketItemModel>> patchBasket({
    required PatchBasketBody body,
  });
}