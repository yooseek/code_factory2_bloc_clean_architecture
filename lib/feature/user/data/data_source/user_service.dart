import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/basket_item_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/patch_basket_body_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

part 'user_service.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  @GET('/basket')
  @Headers({'accessToken': 'true'})
  Future<List<BasketItemModel>> getBasket();

  @PATCH('/basket')
  @Headers({'accessToken': 'true'})
  Future<List<BasketItemModel>> patchBasket({
    @Body() required PatchBasketBody body,
  });
}
