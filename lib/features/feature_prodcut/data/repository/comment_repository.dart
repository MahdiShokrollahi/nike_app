import 'package:dartz/dartz.dart';
import 'package:nike_app/common/error_handling/app_exceptions.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/features/feature_prodcut/data/data_source/comment_data_source.dart';

abstract class ICommentRepository {
  Future<dynamic> getAll(int productId);
  Future<dynamic> insert(String title, String content, int productId);
}

class CommentRepository extends ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);
  @override
  Future<dynamic> getAll(int productId) async {
    try {
      var response = await dataSource.getAll(productId);
      return right(response);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }

  @override
  Future insert(String title, String content, int productId) async {
    try {
      var response = await dataSource.insert(title, content, productId);
      return right(response);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }
}
