import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:code_factory2_bloc_clean_architecture/core/configs/data_const.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/entities/user_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/use_case/get_me.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/use_case/login.dart';
import 'package:code_factory2_bloc_clean_architecture/injection_container.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FlutterSecureStorage secureStorage;
  final GetMe getMe;
  final LogIn logIn;

  UserBloc({
    required this.secureStorage,
    required this.logIn,
    required this.getMe,
  }) : super(UserState.initial()) {

    on<UserModelGetMeEvent>(_userModelGetMeEvent, transformer: droppable());
    on<UserModelLoginEvent>(_userModelLoginEvent);
    on<UserModelLogoutEvent>(_userModelLogoutEvent);

  }
  Future<void> _userModelGetMeEvent(UserModelGetMeEvent event, emit) async {
    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);

    if(refreshToken == null && accessToken == null){
      add(UserModelLogoutEvent());
      return;
    }

    if (refreshToken == null || accessToken == null) {
      emit(state.copyWith(userModel: null,userStatus: UserStatus.empty));
      return;
    }

    try {
      final response = await getMe.call(null);
      emit(state.copyWith(userModel: response,userStatus: UserStatus.loaded));
    } catch (e) {
      emit(state.copyWith(userStatus: UserStatus.error));
    }
  }


  Future<void> _userModelLoginEvent (UserModelLoginEvent event, emit) async {
    emit(state.copyWith(userStatus: UserStatus.loading));

    try {
      final response = await logIn.call(LoginParams(username: event.username, password: event.password));

      await secureStorage.write(
          key: REFRESH_TOKEN_KEY, value: response.refreshToken);
      await secureStorage.write(
          key: ACCESS_TOKEN_KEY, value: response.accessToken);

      final UserModel userResponse = await getMe.call(null);

      emit(state.copyWith(userModel: userResponse,userStatus: UserStatus.loaded));
    } catch (e) {
      emit(state.copyWith(userStatus: UserStatus.error));
    }
  }

  Future<void> _userModelLogoutEvent(UserModelLogoutEvent event, emit) async {
    emit(state.copyWith(userModel: null,userStatus: UserStatus.empty));

    await Future.wait([
      secureStorage.delete(key: REFRESH_TOKEN_KEY),
      secureStorage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
