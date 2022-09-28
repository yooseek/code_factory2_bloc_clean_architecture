import 'package:code_factory2_bloc_clean_architecture/core/domain/use_case.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/user_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/repository/user_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GetMe implements UseCase<UserModel, NoParams> {
  final UserRepository userRepository;

  const GetMe({
    required this.userRepository,
  });

  @override
  Future<UserModel> call(NoParams? noParams) async {
    final userModel = await userRepository.getMe();

    return userModel;
  }
}
