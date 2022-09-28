import 'package:code_factory2_bloc_clean_architecture/core/domain/use_case.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/login_response_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

class LogIn implements UseCase<LoginResponse, LoginParams> {
  final AuthRepository authRepository;

  const LogIn({
    required this.authRepository,
  });

  @override
  Future<LoginResponse> call(LoginParams loginParams) async {
    final loginResponse = await authRepository.login(username: loginParams.username, password: loginParams.password);

    return loginResponse;
  }
}

class LoginParams extends Equatable{
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}