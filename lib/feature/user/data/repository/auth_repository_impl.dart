import 'package:code_factory2_bloc_clean_architecture/core/error/http_error.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/data/data_source/auth_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/login_response_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/token_response_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/repository/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  const AuthRepositoryImpl({
    required this.authService
  });

  @override
  Future<LoginResponse> login({required String username, required String password}) async {
    try{
      final loginResponse = await authService.login(username: username, password: password);

      return loginResponse;
    }on DioError catch(e) {
      throw httpErrorHandler(e);
    }
  }

  @override
  Future<TokenResponse> token() async {
    try{
      return await authService.token();
    }on DioError catch(e) {
      throw httpErrorHandler(e);
    }
  }
}