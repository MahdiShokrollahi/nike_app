// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

abstract class AppException {
  String message;
  Response? response;
  AppException({
    required this.message,
    this.response,
  });

  String getMessage() {
    return '$message';
  }
}

class ServerException extends AppException {
  ServerException({String? message})
      : super(message: message ?? "مشکلی پیش آمده لطفا دوباره امتحان کنید.");
}

class NotFoundException extends AppException {
  NotFoundException({String? message})
      : super(message: message ?? "صفحه مورد نظر یافت نشد.");
}

class DataParsingException extends AppException {
  DataParsingException({String? message})
      : super(message: message ?? "Data has Corrupted");
}

class BadRequestException extends AppException {
  BadRequestException({String? message, Response? response})
      : super(message: message ?? "bad request exception.", response: response);
}

class FetchDataException extends AppException {
  FetchDataException({String? message})
      : super(message: message ?? "please check your connection...");
}

class UnauthorizedException extends AppException {
  UnauthorizedException({String? message})
      : super(message: message ?? "token has been expired.");
}
