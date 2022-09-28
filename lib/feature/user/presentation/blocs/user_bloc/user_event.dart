part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserModelGetMeEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

class UserModelLoginEvent extends UserEvent {
  final String username;
  final String password;

  const UserModelLoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class UserModelLogoutEvent extends UserEvent {
  @override
  List<Object> get props => [];
}