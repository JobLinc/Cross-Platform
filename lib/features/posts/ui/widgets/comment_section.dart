import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/features/login/ui/widgets/custom_rounded_textfield.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/ui/widgets/comment.dart';

class CommentSection extends StatelessWidget {
  final TextEditingController _commentController = TextEditingController();
  CommentSection({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                spacing: 10,
                children: [
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
                        itemCount: 20,
                        itemBuilder: (context, index) => Comment(
                              data: mockCommentData,
                            )),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            CommentBottomBar(
              commentController: _commentController,
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
    required this.commentController,
  });
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        CircleAvatar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomRoundedTextFormField(
              controller: commentController,
              filled: false,
              borderRadius: BorderRadius.circular(40),
              hintText: "Add a comment...",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.send))
      ],
    );
  }
}
