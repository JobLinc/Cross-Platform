import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/data/repos/comment_repo.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';
import 'package:joblinc/features/posts/ui/widgets/user_header.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Comment extends StatelessWidget {
  const Comment({
    super.key,
    required this.data,
  });

  final CommentModel data;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> likeCount = ValueNotifier(data.likeCount);
    return Padding(
      padding: EdgeInsets.only(left: data.isReply ? 50 : 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserHeader(
            imageURL: data.profilePictureURL,
            username: data.username,
            headline: data.headline,
            senderID: data.senderID,
            //TODO FIX COMMENTS
            isCompany: false,
            action: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 3.0, bottom: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(data.text),
                Row(
                  children: [
                    CommentReactionButton(
                      commentId: data.commentID,
                      userReaction: data.userReaction,
                      initialLikeCount: data.likeCount,
                      likeCount: likeCount,
                    ),
                    ValueListenableBuilder(
                      valueListenable: likeCount,
                      builder: (context, value, child) => Text('  $value'),
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
      ),
    );
  }
}

class CommentReactionButton extends StatelessWidget {
  const CommentReactionButton({
    super.key,
    required this.commentId,
    required this.userReaction,
    required this.initialLikeCount,
    required this.likeCount,
  });
  final String commentId;
  final Reactions? userReaction;
  final int initialLikeCount;
  final ValueNotifier<int> likeCount;

  @override
  Widget build(BuildContext context) {
    return ReactionButton(
        onReactionChanged: (item) {
          if (item?.value != null) {
            try {
              getIt
                  .get<CommentRepo>()
                  .reactToComment(commentId, (item?.value)!);
            } on Exception catch (e) {
              CustomSnackBar.show(
                context: context,
                message: e.toString(),
                type: SnackBarType.error,
              );
            }
            if (userReaction == null && initialLikeCount == likeCount.value) {
              likeCount.value++;
            }
          }
        },
        isChecked: userReaction != null,
        selectedReaction: getReaction(userReaction, isComment: true),
        itemsSpacing: 10,
        toggle: false,
        placeholder: Reaction(
          value: null,
          icon: Icon(
            LucideIcons.smilePlus,
            size: 18,
          ),
        ),
        reactions: [
          Reaction(
            value: Reactions.like,
            icon: Icon(
              LucideIcons.thumbsUp,
              color: Colors.blue,
              size: 18,
            ),
          ),
          Reaction(
            value: Reactions.celebrate,
            icon: Icon(
              LucideIcons.partyPopper,
              color: Colors.pink,
              size: 18,
            ),
          ),
          Reaction(
            value: Reactions.support,
            icon: Icon(
              LucideIcons.helpingHand,
              color: Colors.green.shade600,
              size: 18,
            ),
          ),
          Reaction(
            value: Reactions.funny,
            icon: Icon(
              LucideIcons.laugh,
              color: Colors.purple.shade600,
              size: 18,
            ),
          ),
          Reaction(
            value: Reactions.love,
            icon: Icon(
              LucideIcons.heart,
              color: Colors.red.shade600,
              size: 18,
            ),
          ),
          Reaction(
            value: Reactions.insightful,
            icon: Icon(
              LucideIcons.lightbulb,
              color: Colors.yellow.shade600,
              size: 18,
            ),
          ),
        ],
        itemSize: Size(24, 24));
  }
}
