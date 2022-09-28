import 'package:code_factory2_bloc_clean_architecture/core/utils/data_util.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/login_response_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/token_response_model.dart';
import 'package:dio/dio.dart';

abstract class AuthService {
  Future<LoginResponse> login({
    required String username,
    required String password,
  });
  Future<TokenResponse> token();
}

class AuthServiceImpl implements AuthService {
  final String baseUrl;
  final Dio dio;

  const AuthServiceImpl({
    required this.baseUrl,
    required this.dio,
  });

  @override
  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    // 아이디 비번 인코딩
    // 토큰으로 생성
    final serialized = DataUtils.plainTobase64('$username:$password');

    // 헤더에 토큰 달고 api 요청
    final response = await dio.post(
      '$baseUrl/login',
      options: Options(headers: {
        'authorization': 'Basic $serialized',
      }),
    );

    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<TokenResponse> token() async {
    final response = await dio.post(
      '$baseUrl/token',
      options: Options(headers: {'refreshToken': 'true'}),
    );

    return TokenResponse.fromJson(response.data);
  }
}
