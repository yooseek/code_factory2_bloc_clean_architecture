import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/login_response_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/token_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponse> login({
    required String username,
    required String password,
  });

  Future<TokenResponse> token();
}