import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/login/ui/widgets/custom_rounded_textfield.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/data/repos/comment_repo.dart';
import 'package:joblinc/features/posts/ui/widgets/comment.dart';

class CommentSection extends StatelessWidget {
  CommentSection({
    super.key,
    required this.postId,
    required this.comments,
  });
  final List<CommentModel> comments;
  final String postId;

  @override
  Widget build(BuildContext context) {
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
                            child: ListView.builder(
                                itemCount: comments.length,
                                itemBuilder: (context, index) => Comment(
                                      data: comments[index],
                                    )),
                          ),
                        ]
                      : [Center(child: Text('No comments yet'))],
                ),
              ),
            ),
            Divider(
              height: 0,
            ),
            CommentBottomBar(postId: postId)
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
  });
  final String postId;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        spacing: 10,
        children: [
          //TODO set profile image to user image
          ProfileImage(
            imageURL: "",
            radius: 23.r,
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
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  try {
                    getIt
                        .get<CommentRepo>()
                        .addComment(postId, commentController.text);
                  } on Exception catch (e) {
                    CustomSnackBar.show(
                      context: context,
                      message: e.toString(),
                      type: SnackBarType.error,
                    );
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
