import 'package:dio/dio.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/features/feature_home/data/model/banner.dart';

abstract class IBannerDataSource {
  Future<List<BannerModel>> getAll();
}

class BannerRemoteDataSource extends IBannerDataSource {
  final Dio dio;

  BannerRemoteDataSource(this.dio);
  @override
  Future<List<BannerModel>> getAll() async {
    try {
      final response = await dio.get('banner/slider');
      List<BannerModel> bannerList = response.data
          .map<BannerModel>((banner) => BannerModel.fromJson(banner))
          .toList();

      return bannerList;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }
}
