part of 'comment_bloc.dart';

abstract class InsertCommentDataStatus extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InsertCommentDataInitial extends InsertCommentDataStatus {}

class InsertCommentDataLoading extends InsertCommentDataStatus {}

class InsertCommentDataSuccess extends InsertCommentDataStatus {
  final CommentModel comment;

  InsertCommentDataSuccess(this.comment);

  @override
  // TODO: implement props
  List<Object?> get props => [comment];
}

class InsertCommentDataError extends InsertCommentDataStatus {
  final String error;

  InsertCommentDataError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
