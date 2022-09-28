import 'package:code_factory2_bloc_clean_architecture/core/presentation/bloc/logger.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/presentation/bloc/rating_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/basket_bloc/basket_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await initializeDependencies();

  Bloc.observer = Logger();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context)=> serviceLocator()..add(UserModelGetMeEvent()),lazy: false),
        BlocProvider<AuthBloc>(create: (context)=> serviceLocator()),
        BlocProvider<RestaurantBloc>(create: (context)=> serviceLocator()..add(const GetRestaurantListEvent()),lazy: false,),
        BlocProvider<RatingBloc>(create: (context)=> serviceLocator()),
        BlocProvider<BasketBloc>(create: (context)=> serviceLocator()),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), //터치시 키보드 내리기
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerDelegate: serviceLocator<GoRouter>().routerDelegate,
          routeInformationParser: serviceLocator<GoRouter>().routeInformationParser,
          routeInformationProvider: serviceLocator<GoRouter>().routeInformationProvider,
        ),
      ),
    );
  }
}