part of 'user_bloc.dart';

enum UserStatus {
  initial,
  empty,
  loading,
  loaded,
  error,
}

class UserState extends Equatable {
  final UserModel? userModel;
  final UserStatus userStatus;

  const UserState({
    required this.userModel,
    this.userStatus = UserStatus.initial,
  });

  factory UserState.initial() {

    return const UserState(userModel: null);
  }

  UserState copyWith({
    UserModel? userModel,
    UserStatus? userStatus,
  }) {
    return UserState(
      userModel: userModel ?? this.userModel,
      userStatus: userStatus ?? this.userStatus,
    );
  }

  @override
  List<Object?> get props => [userModel, userStatus];
}