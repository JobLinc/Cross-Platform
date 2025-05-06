import 'package:flutter/material.dart';
import 'package:joblinc/features/posts/data/models/reaction_model.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';
import 'package:joblinc/features/posts/ui/widgets/user_header.dart';

class PostReactions extends StatelessWidget {
  const PostReactions({super.key, required this.reactions});
  final List<ReactionModel> reactions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reactions.length,
      itemBuilder: (context, index) {
        final reaction = reactions[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                UserHeader(
                  imageURL: reaction.profilePicture,
                  username: reaction.username,
                  headline: reaction.headline,
                  senderID: reaction.reactorId,
                  isCompany: reaction.isCompany,
                  timestamp: reaction.time,
                ),
              ],
            ),
            // getReaction(reaction.type).icon
          ],
        );
      },
    );
  }
}
