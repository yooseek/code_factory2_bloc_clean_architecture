import 'package:json_annotation/json_annotation.dart';

part 'response_dto.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class ResponseDto<T> {
  final ResponseMeta meta;
  final List<T> data;

  ResponseDto({
    required this.meta,
    required this.data,
  });

  factory ResponseDto.fromJson(Map<String,dynamic> json, T Function(Object? json) fromJsonT) =>
  _$ResponseDtoFromJson(json, fromJsonT);

  ResponseDto copyWith({
    ResponseMeta? meta,
    List<T>? data,
  }) {
    return ResponseDto<T>(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }
}


@JsonSerializable()
class ResponseMeta {
  final int count;
  final bool hasMore;

  const ResponseMeta({
    required this.count,
    required this.hasMore,
  });

  factory ResponseMeta.fromJson(Map<String, dynamic> json) =>
      _$ResponseMetaFromJson(json);

  ResponseMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return ResponseMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}