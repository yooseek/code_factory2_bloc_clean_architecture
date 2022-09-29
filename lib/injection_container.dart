import 'package:code_factory2_bloc_clean_architecture/core/configs/data_const.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/data_source/dio_interceptor.dart';
import 'package:code_factory2_bloc_clean_architecture/core/network/network_info.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/data/data_source/order_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/data/repository/order_repository_impl.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/repository/order_repository.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/use_case/get_order_list.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/domain/use_case/post_order.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/order/presentation/blocs/order_bloc/order_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/data/data_source/product_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/data/repository/product_repository_impl.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/repository/product_repository.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/domain/use_case/get_product_list.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/product/presentation/blocs/product_bloc/product_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/data/data_source/rating_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/data/respository/rating_repository_impl.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/domain/repository/rating_repository.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/domain/use_case/get_rating_list.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/rating/presentation/bloc/rating_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/data/data_source/restaurant_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/data/data_source/restaurant_service_local.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/data/repository/restaurant_repository_impl.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/repository/restaurant_repository.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/use_case/get_restaurant_detail.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/use_case/get_restaurant_list.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/data/data_source/auth_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/data/data_source/user_service.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/data/repository/auth_repository_impl.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/data/repository/user_repository_impl.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/repository/auth_repository.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/repository/user_repository.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/use_case/get_basket.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/use_case/get_me.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/use_case/login.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/domain/use_case/patch_basket.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/basket_bloc/basket_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  //core
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: serviceLocator()));

  //local database
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  serviceLocator.registerLazySingleton<HiveInterface>(() => Hive..registerAdapter(RestaurantModelAdapter()));
  // serviceLocator.registerLazySingletonAsync(() => SharedPreferences.getInstance());

  //dio retrofit
  serviceLocator.registerLazySingleton<Dio>(() => Dio()..interceptors.add(CustomInterceptor(storage: serviceLocator())));

  //data source(service)
  serviceLocator.registerLazySingleton<RestaurantService>(() => RestaurantService(serviceLocator(),baseUrl: 'http://$ip/restaurant'));
  serviceLocator.registerLazySingleton<RatingService>(() => RatingService(serviceLocator(),baseUrl: 'http://$ip/restaurant'));
  serviceLocator.registerLazySingleton<OrderService>(() => OrderService(serviceLocator(),baseUrl: 'http://$ip/order'));
  serviceLocator.registerLazySingleton<ProductService>(() => ProductService(serviceLocator(),baseUrl: 'http://$ip/product'));
  serviceLocator.registerLazySingleton<RestaurantServiceLocal>(() => RestaurantServiceLocalImpl(hiveDatabase: serviceLocator()));
  serviceLocator.registerLazySingleton<UserService>(() => UserService(serviceLocator(),baseUrl: 'http://$ip/user/me'));
  serviceLocator.registerLazySingleton<AuthService>(() => AuthServiceImpl(dio: serviceLocator(), baseUrl: 'http://$ip/auth'));
  //repoimpl
  serviceLocator.registerLazySingleton<RestaurantRepository>(() => RestaurantRepositoryImpl(restaurantService: serviceLocator(), networkInfo: serviceLocator()));
  serviceLocator.registerLazySingleton<RatingRepository>(() => RatingRepositoryImpl(ratingService: serviceLocator()));
  serviceLocator.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(orderService: serviceLocator()));
  serviceLocator.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(productService: serviceLocator()));
  serviceLocator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(userService: serviceLocator()));
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authService: serviceLocator()));
  //usecases
  serviceLocator.registerLazySingleton<GetRestaurantList>(() => GetRestaurantList(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetRestaurantDetail>(() => GetRestaurantDetail(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetMe>(() => GetMe(userRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetBasket>(() => GetBasket(userRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<PatchBasket>(() => PatchBasket(userRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetRatingList>(() => GetRatingList(ratingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<PostOrder>(() => PostOrder(orderRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetOrderList>(() => GetOrderList(orderRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetProductList>(() => GetProductList(productRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<LogIn>(() => LogIn(authRepository: serviceLocator()));
  //blocs
  serviceLocator.registerFactory<RestaurantBloc>(() => RestaurantBloc(getRestaurantList: serviceLocator(),getRestaurantDetail: serviceLocator()));
  serviceLocator.registerFactory<AuthBloc>(() => AuthBloc(userBloc: serviceLocator()));
  serviceLocator.registerFactory<RatingBloc>(() => RatingBloc(getRatingList: serviceLocator()));
  serviceLocator.registerFactory<OrderBloc>(() => OrderBloc(postOrder: serviceLocator(), getOrderList: serviceLocator(), basketBloc: serviceLocator()));
  serviceLocator.registerFactory<ProductBloc>(() => ProductBloc(getProductList: serviceLocator()));
  /// stream 생성하는 bloc은 singleton을 유지해야한다.
  serviceLocator.registerLazySingleton<UserBloc>(() => UserBloc(secureStorage: serviceLocator(), logIn: serviceLocator(), getMe: serviceLocator()));
  /// 다른 BLoc에서 참조하는 bloc은 singleton을 유지해야한다.
  serviceLocator.registerLazySingleton<BasketBloc>(() => BasketBloc(getBasket: serviceLocator(), patchBasket: serviceLocator()));


  // go_router
  serviceLocator.registerLazySingleton<GoRouter>(() => GoRouter(
    routes: serviceLocator<AuthBloc>().routes,
    initialLocation: '/splash',
    refreshListenable: serviceLocator<AuthBloc>(),
    redirect: serviceLocator<AuthBloc>().redirectLogic,
  ));
}