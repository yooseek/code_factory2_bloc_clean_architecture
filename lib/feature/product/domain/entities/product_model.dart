import 'package:code_factory2_bloc_clean_architecture/core/model/model_with_id.dart';
import 'package:code_factory2_bloc_clean_architecture/core/utils/data_util.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements IModelWithId {
  final String id;
  // 상품 이름
  final String name;
  final String detail;
  @JsonKey(
      fromJson: DataUtils.pathToUrl
  )
  final String imgUrl;
  final int price;
  final RestaurantModel restaurant;

  ProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
    required this.restaurant,
  });

  factory ProductModel.fromJson(Map<String,dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}