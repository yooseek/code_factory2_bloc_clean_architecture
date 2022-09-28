import 'package:code_factory2_bloc_clean_architecture/core/error/exception.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';
import 'package:floor/floor.dart';
import 'package:hive/hive.dart';

abstract class RestaurantServiceLocal {
  Future<List<RestaurantModel>> getRestaurantList();
}

class RestaurantServiceLocalImpl implements RestaurantServiceLocal {
  // final FloorDatabase floorDatabase;
  final HiveInterface hiveDatabase;

  const RestaurantServiceLocalImpl({
    // required this.floorDatabase,
    required this.hiveDatabase,
  });

  @override
  Future<List<RestaurantModel>> getRestaurantList() async {
    // hive 또는 floor 데이터 베이스를 이용하기

    // 예시

    // hiveDatabase.registerAdapter(RestaurantModelAdapter());  - 옮겨야함
    // final restaurantList = await hiveDatabase.openBox<RestaurantModel>('cache_restaurant_list');
    //
    // final tempModel = RestaurantModel();
    // restaurantList.add(tempModel); // 모델로 직접넣기
    // restaurantList.put('key', tempModel); // key, model로 넣기
    //
    // final list = restaurantList.values; // 박스 안에 모든 값
    // restaurantList.get('key'); // 키로 불러올 값
    //
    // if(list.isEmpty) {
    //   throw CacheException();
    // }else{
    //   return list.toList();
    // }
    return [];
  }

}