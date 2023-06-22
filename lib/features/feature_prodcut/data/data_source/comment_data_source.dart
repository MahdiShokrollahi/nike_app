import 'package:dio/dio.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/features/feature_prodcut/data/model/comment.dart';

abstract class ICommentDataSource {
  Future<List<CommentModel>> getAll(int productId);
  Future<CommentModel> insert(String title, String content, int productId);
}

class CommentRemoteDataSource extends ICommentDataSource {
  final Dio dio;

  CommentRemoteDataSource(this.dio);
  @override
  Future<List<CommentModel>> getAll(int productId) async {
    try {
      final response = await dio.get('comment/list?product_id=$productId');
      List<CommentModel> commentList = response.data
          .map<CommentModel>((banner) => CommentModel.fromJson(banner))
          .toList();

      return commentList;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }

  @override
  Future<CommentModel> insert(
      String title, String content, int productId) async {
    try {
      final response = await dio.post('comment/add',
          data: {"title": title, "content": content, "product_id": productId});

      final commentModel = CommentModel.fromJson(response.data);

      return commentModel;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }
}
