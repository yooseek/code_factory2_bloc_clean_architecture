import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';
import 'package:hive/hive.dart';

List<TypeAdapter> adapterList = [
  RestaurantModelAdapter(),
];