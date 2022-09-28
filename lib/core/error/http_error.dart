import 'package:dio/dio.dart';

String httpErrorHandler(DioError response) {
  final statusCode = response.error.statusCode;
  final reasonPhrase = response.error.toString();

  final String errorMessage =
      'Request failed\nStatus Code: $statusCode\nReason: $reasonPhrase';
  return errorMessage;
}
