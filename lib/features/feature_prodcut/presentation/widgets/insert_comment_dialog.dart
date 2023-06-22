import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/utils/custom_snackbar.dart';
import 'package:nike_app/features/feature_prodcut/presentation/blocs/comment_bloc/comment_bloc.dart';

class InsertCommentDialog extends StatefulWidget {
  InsertCommentDialog({super.key, required this.productId});
  final int productId;

  @override
  State<InsertCommentDialog> createState() => _InsertCommentDialogState();
}

class _InsertCommentDialogState extends State<InsertCommentDialog> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CommentBloc(locator());
        return bloc;
      },
      child:
          BlocConsumer<CommentBloc, CommentState>(listener: (context, state) {
        if (state.insertCommentDataStatus is InsertCommentDataSuccess) {
          CustomSnackbar.showSnackbar(context,
              message: 'نظر شما با موفقیت ثبت شد و پس از تایید منتشر خواهد شد');
          Navigator.of(context, rootNavigator: true).pop();
        }
        if (state.insertCommentDataStatus is InsertCommentDataError) {
          InsertCommentDataError insertCommentDataError =
              state.insertCommentDataStatus as InsertCommentDataError;
          CustomSnackbar.showSnackbar(context,
              message: insertCommentDataError.error);
          Navigator.of(context, rootNavigator: true).pop();
        }
      }, builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 300,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('ثبت نظر',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(label: Text('عنوان')),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                        label: Text('متن نظر خود را اینجا وارد کنید')),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56)),
                      onPressed: () {
                        BlocProvider.of<CommentBloc>(context).add(InsertComment(
                            titleController.text,
                            contentController.text,
                            widget.productId));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.insertCommentDataStatus
                              is InsertCommentDataLoading)
                            const CupertinoActivityIndicator(),
                          const Text(
                            'ذخیره',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
