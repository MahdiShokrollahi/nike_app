// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadComments extends CommentEvent {
  final int productId;

  LoadComments(this.productId);
}

class InsertComment extends CommentEvent {
  final String title;
  final String content;
  final int productId;

  InsertComment(this.title, this.content, this.productId);
}
