import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_app/common/utils/prefs_operator.dart';
import 'package:nike_app/features/feature_prodcut/data/model/comment.dart';
import 'package:nike_app/features/feature_prodcut/data/repository/comment_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';
part 'comment_data_status.dart';
part 'insert_comment_data_status.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final ICommentRepository commentRepository;
  CommentBloc(this.commentRepository)
      : super(CommentState(
          commentDataStatus: CommentDataLoading(),
          insertCommentDataStatus: InsertCommentDataInitial(),
          commentList: [],
          startIndex: 0,
          isLoading: false,
        )) {
    on<LoadComments>((event, emit) async {
      if (state.startIndex == 0) {
        emit(state.copyWith(newCommentDataStatus: CommentDataLoading()));
      } else {
        emit(state.copyWith(newIsLoading: true));
      }
      var result = await commentRepository.getAll(event.productId);
      result.fold((error) {
        emit(state.copyWith(newCommentDataStatus: CommentDataError(error)));
      }, (commentList) {
        int endIndex = state.startIndex + 9;
        if (endIndex >= commentList.length) {
          emit(state.copyWith(
              newCommentDataStatus: CommentDataSuccess(commentList),
              newCommentList: state.commentList
                ..addAll(commentList.sublist(state.startIndex)),
              newStartIndex: state.commentList.length,
              newIsLoading: false));
        } else {
          emit(state.copyWith(
              newCommentDataStatus: CommentDataSuccess(commentList),
              newCommentList: state.commentList
                ..addAll(commentList.sublist(state.startIndex, endIndex + 1)),
              newStartIndex: state.commentList.length,
              newIsLoading: false));
        }
      });
    });

    on<InsertComment>((event, emit) async {
      if (!PrefsOperator.inUserLoggedIn()) {
        emit(state.copyWith(
            newInsertCommentDataStatus:
                InsertCommentDataError("لطفا وارد حساب کاربری خود شوید")));
      } else {
        emit(state.copyWith(
            newInsertCommentDataStatus: InsertCommentDataLoading()));
        if (event.title.isNotEmpty && event.content.isNotEmpty) {
          final result = await commentRepository.insert(
              event.title, event.content, event.productId);
          result.fold((error) {
            emit(state.copyWith(
                newInsertCommentDataStatus: InsertCommentDataError(error)));
          }, (comment) {
            emit(state.copyWith(
                newInsertCommentDataStatus: InsertCommentDataSuccess(comment)));
          });
        } else {
          emit(state.copyWith(
              newInsertCommentDataStatus: InsertCommentDataError(
                  'لطفا عنوان و متن مورد نظر را پر کنید')));
        }
      }
    });
  }
}
