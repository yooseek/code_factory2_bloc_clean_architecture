import 'dart:async';
import 'package:code_factory2_bloc_clean_architecture/core/presentation/screens/root_tab.dart';
import 'package:code_factory2_bloc_clean_architecture/core/presentation/screens/splash_screen.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/presentation/screens/order_done_screen.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/screens/basket_screen.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/screens/restaurant_detail_screen.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/screnns/login_screen.dart';
import 'package:code_factory2_bloc_clean_architecture/injection_container.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc/bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with ChangeNotifier {
  final UserBloc userBloc;
  late final StreamSubscription userModelSubscription;

  AuthBloc({required this.userBloc}) : super(AuthInitial()) {
    userModelSubscription = userBloc.stream.listen((event) {
      notifyListeners();
    });

    on<AuthLogoutEvent>(
      _authLogoutEvent,
      transformer: droppable(),
    );
  }

  @override
  Future<void> close() {
    userModelSubscription.cancel();
    return super.close();
  }

  Future<void> _authLogoutEvent(AuthLogoutEvent event, emit) async {
    userBloc.add(UserModelLogoutEvent());
  }

  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const RootTab(),
            routes: [
              GoRoute(
                path: 'restaurant/:rid',
                name: 'restaurantDetail',
                builder: (context, state) =>
                    RestaurantDetailScreen(id: state.params['rid']!),
              ),
            ]
        ),
        GoRoute(
            path: '/splash',
            name: 'splash',
            builder: (context, state) => const SplashScreen()),
        GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => const LoginScreen()),
        GoRoute(
            path: '/basket',
            name: 'basket',
            builder: (context, state) => const BasketScreen()),
        GoRoute(
            path: '/order_done',
            name: 'order_done',
            builder: (context, state) => const OrderDoneScreen()),
      ];

  String? redirectLogic(GoRouterState state) {
    final user = userBloc.state.userModel;

    final logging = state.location == '/login';

    // ??? ????????? ?????? ?????? ???
    if(state.location == '/splash' && userBloc.state.userStatus == UserStatus.initial){
      return null;
    }

    // ?????? ????????? ????????? ????????? ?????????
    // ????????? ????????? ???????????? ??????
    // ?????? ????????? ?????? ???????????? ????????? ???????????? ??????
    if (user == null || userBloc.state.userStatus == UserStatus.empty) {
      return logging ? null : '/login';
    }

    // ?????? ????????? ?????? ???
    if (userBloc.state.userStatus == UserStatus.loaded) {
      // ????????? ???????????? ?????? ????????? splash ??????????????? ????????? ??????
      if (logging || state.location == '/splash') {
        return '/';
      } else {
        // ????????? ?????? ????????? ????????? ??????
        return null;
      }
    }

    if (userBloc.state.userStatus == UserStatus.error) {
      return !logging ? '/login' : null;
    }

    return null;
  }
}
