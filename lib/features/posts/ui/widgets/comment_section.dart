import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/user_service.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/login/ui/widgets/custom_rounded_textfield.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/data/repos/comment_repo.dart';
import 'package:joblinc/features/posts/ui/widgets/comment.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
    required this.postId,
    required this.comments,
  });
  final List<CommentModel> comments;
  final String postId;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<CommentModel>> commentsNotifier =
        ValueNotifier(comments);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: comments.isNotEmpty
                      ? [
                          GestureDetector(
                            //TODO implement this sort
                            onTap: () {},
                            child: Row(
                              children: [
                                Text(
                                  'Most relevant',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeightHelper.semiBold),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: commentsNotifier,
                              builder: (context, commentsList, child) =>
                                  ListView.builder(
                                itemCount: commentsList.length,
                                itemBuilder: (context, index) => Comment(
                                  data: commentsList[index],
                                ),
                              ),
                            ),
                          ),
                        ]
                      : [Center(child: Text('No comments yet'))],
                ),
              ),
            ),
            Divider(
              height: 0,
            ),
            CommentBottomBar(
              postId: postId,
              commentNotifier: commentsNotifier,
            )
          ],
        ),
      ),
    );
  }
}

class CommentBottomBar extends StatelessWidget {
  CommentBottomBar({
    super.key,
    required this.postId,
    required this.commentNotifier,
  });
  final String postId;
  final TextEditingController commentController = TextEditingController();
  final ValueNotifier<List<CommentModel>> commentNotifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        spacing: 10,
        children: [
          FutureBuilder(
            future: UserService.getProfilePicture(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ProfileImage(imageURL: snapshot.data);
              } else {
                return ProfileImage(imageURL: null);
              }
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomRoundedTextFormField(
                controller: commentController,
                filled: false,
                borderRadius: BorderRadius.circular(40),
                hintText: "Add a comment...",
                hintStyle: TextStyle(color: Colors.grey),
                autofocus: true,
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                if (commentController.text.isNotEmpty) {
                  try {
                    final repo = getIt.get<CommentRepo>();
                    final commentId =
                        await repo.addComment(postId, commentController.text);
                        
                    // commentNotifier.value
                    //     .add(await repo.getComment(postId, commentId));
                    commentNotifier.value = await repo.getComments(postId);

                    commentController.text = '';
                  } on Exception catch (e) {
                    if (context.mounted) {
                      CustomSnackBar.show(
                        context: context,
                        message: e.toString(),
                        type: SnackBarType.error,
                      );
                    }
                  }
                }
              },
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}

Future<dynamic> showCommentSectionBottomSheet(
    BuildContext context, String postId, List<CommentModel> comments) {
  return showModalBottomSheet(
    showDragHandle: true,
    scrollControlDisabledMaxHeightRatio: 0.9,
    context: context,
    builder: (context) {
      return CommentSection(
        postId: postId,
        comments: comments,
      );
    },
  );
}
