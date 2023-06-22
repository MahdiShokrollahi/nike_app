import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/utils/constants.dart';
import 'package:nike_app/common/utils/theme_color.dart';
import 'package:nike_app/common/widgets/app_error_widget.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';
import 'package:nike_app/features/feature_prodcut/data/model/comment.dart';
import 'package:nike_app/features/feature_prodcut/presentation/blocs/comment_bloc/comment_bloc.dart';

class CommentList extends StatefulWidget {
  CommentList({super.key, required this.product});
  final ProductModel product;

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  final ScrollController scrollController = ScrollController();
  CommentBloc? commentBloc;
  @override
  void initState() {
    scrollController.addListener(setUpScrollController);
    super.initState();
  }

  setUpScrollController() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {
      commentBloc?.add(LoadComments(widget.product.id));
    }
  }

  @override
  void dispose() {
    commentBloc?.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CommentBloc(locator());
        commentBloc = bloc;
        bloc.add(LoadComments(widget.product.id));
        return bloc;
      },
      child: BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
        if (state.commentDataStatus is CommentDataLoading) {
          return SliverToBoxAdapter(
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: LightThemeColors.primaryTextColor, size: 40),
            ),
          );
        }
        if (state.commentDataStatus is CommentDataSuccess) {
          var commentList = state.commentList;
          return SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverToBoxAdapter(
              child: FadeInDown(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    if (state.isLoading)
                      const Positioned(
                          bottom: 30,
                          child: CupertinoActivityIndicator(
                            radius: 13,
                          )),
                    SizedBox(
                      height: 700,
                      child: ListView.builder(
                          itemCount: commentList.length,
                          controller: scrollController,
                          physics: Constants.defaultScrollPhysic,
                          itemBuilder: (context, index) {
                            var comment = commentList[index];

                            return CommentItem(comment: comment);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state.commentDataStatus is CommentDataError) {
          CommentDataError commentDataError =
              state.commentDataStatus as CommentDataError;
          var error = commentDataError.error;
          return SliverToBoxAdapter(
            child: AppErrorWidget(
              exception: error,
              onTap: () {
                BlocProvider.of<CommentBloc>(context)
                    .add(LoadComments(widget.product.id));
              },
            ),
          );
        }
        return Container();
      }),
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.comment,
  });
  final CommentModel comment;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(color: themeData.dividerColor, width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.title),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    comment.email,
                    style: themeData.textTheme.bodySmall,
                  ),
                ],
              ),
              Text(comment.date, style: themeData.textTheme.bodySmall),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            comment.content,
            style: const TextStyle(height: 1.4),
          ),
        ],
      ),
    );
  }
}
