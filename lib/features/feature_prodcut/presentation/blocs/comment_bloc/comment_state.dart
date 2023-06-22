// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'comment_bloc.dart';

class CommentState extends Equatable {
  CommentDataStatus commentDataStatus;
  InsertCommentDataStatus insertCommentDataStatus;
  List<CommentModel> commentList;
  bool isLoading;
  int startIndex;
  CommentState({
    required this.commentDataStatus,
    required this.insertCommentDataStatus,
    required this.commentList,
    required this.isLoading,
    required this.startIndex,
  });
  CommentState copyWith(
      {CommentDataStatus? newCommentDataStatus,
      InsertCommentDataStatus? newInsertCommentDataStatus,
      List<CommentModel>? newCommentList,
      bool? newIsLoading,
      int? newStartIndex}) {
    return CommentState(
        commentDataStatus: newCommentDataStatus ?? commentDataStatus,
        insertCommentDataStatus:
            newInsertCommentDataStatus ?? insertCommentDataStatus,
        commentList: newCommentList ?? commentList,
        isLoading: newIsLoading ?? isLoading,
        startIndex: newStartIndex ?? startIndex);
  }

  @override
  List<Object> get props => [
        commentDataStatus,
        insertCommentDataStatus,
        isLoading,
        startIndex,
        commentList
      ];
}
