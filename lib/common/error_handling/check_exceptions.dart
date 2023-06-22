import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nike_app/common/error_handling/app_exceptions.dart';

class CheckException {
  static dynamic response(Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response: response);
      case 401:
        throw UnauthorizedException();
      case 404:
        throw NotFoundException();
      case 500:
        throw ServerException();
      default:
        throw FetchDataException(
            message: '${response.statusCode} fetch exception');
    }
  }

  static dynamic getError(AppException appException) {
    switch (appException.runtimeType) {
      case BadRequestException:
        return left(appException.message);
      case ServerException:
        return left(appException.message);
      case NotFoundException:
        return left(appException.message);
      case UnauthorizedException:
        return left(appException.message);
      case FetchDataException:
        return left(appException.message);
    }
  }
}
