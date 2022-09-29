import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read<UserBloc>().add(UserModelLogoutEvent());
        },
        child: Text('로그아웃'),
      ),
    );
  }
}
