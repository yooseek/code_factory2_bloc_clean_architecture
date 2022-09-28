import 'package:code_factory2_bloc_clean_architecture/core/model/model_with_id.dart';
import 'package:code_factory2_bloc_clean_architecture/core/utils/data_util.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
@HiveType(typeId: 1)
class RestaurantModel extends HiveObject implements IModelWithId{
  // id
  @HiveField(0)
  final String id;

  // 레스토랑 이름
  @HiveField(1)
  final String name;

  // 썸네일 url
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  @HiveField(2)
  final String thumbUrl;

  // 레스토랑 태그
  @HiveField(3)
  final List<String> tags;

  // 가격 범위
  @HiveField(4)
  final RestaurantPriceRange priceRange;

  // 평균 평점
  @HiveField(5)
  final double ratings;

  // 평점 갯수
  @HiveField(6)
  final int ratingsCount;

  // 배송걸리는 시간
  @HiveField(7)
  final int deliveryTime;

  // 배송 비용
  @HiveField(8)
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}