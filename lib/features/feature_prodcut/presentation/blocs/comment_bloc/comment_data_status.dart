part of 'comment_bloc.dart';

abstract class CommentDataStatus extends Equatable {}

class CommentDataLoading extends CommentDataStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CommentDataSuccess extends CommentDataStatus {
  final List<CommentModel> commentList;

  CommentDataSuccess(this.commentList);

  @override
  // TODO: implement props
  List<Object?> get props => [commentList];
}

class CommentDataError extends CommentDataStatus {
  final String error;

  CommentDataError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
