import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/ui/widgets/user_header.dart';

class Comment extends StatelessWidget {
  const Comment({
    super.key,
    required this.data,
  });

  final CommentModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserHeader(
          imageURL: data.profilePictureURL,
          username: data.username,
          headline: data.headline,
          senderID: data.senderID,
          action: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: data.isReply ? 20 : 0, top: 3.0, bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(data.text),
              Row(
                children: [
                  TextButton(
                    //TODO implement Like button
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: ColorsManager.charcoalBlack,
                      shape: LinearBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      minimumSize: Size(20, 45),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('Like'),
                  ),
                  Text(' | '),
                  TextButton(
                    //TODO implement Reply button
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: ColorsManager.charcoalBlack,
                      shape: LinearBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      minimumSize: Size(20, 45),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('Reply'),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
