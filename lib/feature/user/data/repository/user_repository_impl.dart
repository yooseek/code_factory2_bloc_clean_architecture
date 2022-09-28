import 'package:code_factory2_bloc_clean_architecture/core/error/http_error.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/data/data_source/user_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/basket_item_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/patch_basket_body_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/user_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/repository/user_repository.dart';
import 'package:dio/dio.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService userService;

  const UserRepositoryImpl({
    required this.userService,
  });

  @override
  Future<UserModel> getMe() async {
    try{
      return await userService.getMe();
    }on DioError catch(e) {
      throw httpErrorHandler(e);
    }
  }

  @override
  Future<List<BasketItemModel>> getBasket() async {
    try{
      return await userService.getBasket();
    }on DioError catch(e) {
      throw httpErrorHandler(e);
    }
  }

  @override
  Future<List<BasketItemModel>> patchBasket({required PatchBasketBody body}) async {
    try{
      return await userService.patchBasket(body: body);
    }on DioError catch(e) {
      throw httpErrorHandler(e);
    }
  }
}