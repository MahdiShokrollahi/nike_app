import 'package:dartz/dartz.dart';
import 'package:nike_app/common/error_handling/app_exceptions.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/features/feature_home/data/data_source/banner_data_source.dart';

abstract class IBannerRepository {
  Future<dynamic> getAll();
}

class BannerRepository extends IBannerRepository {
  final IBannerDataSource bannerDataSource;

  BannerRepository(this.bannerDataSource);

  @override
  Future<dynamic> getAll() async {
    try {
      var response = await bannerDataSource.getAll();
      return right(response);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }
}
