import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import "../../data/models/post_model.dart";

class Post extends StatelessWidget {
  //this will need to be changed to support live updates to likes/comments/reposts
  const Post({super.key, required this.data});
  final PostModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: PostContent(data: data),
        ),
      ),
    );
  }
}

class PostContent extends StatelessWidget {
  const PostContent({
    super.key,
    required this.data,
  });

  final PostModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PostHeader(
          imageURL: data.profilePictureURL,
          username: data.username,
          affiliation: data.affiliation,
        ),
        PostBody(
          text: data.text,
        ),
        data.attachmentURLs.isNotEmpty
            ? PostAttachments(attachmentURLs: data.attachmentURLs)
            : SizedBox(),
        PostNumerics(
          likesCount: data.likesCount,
          commentCount: data.commentCount,
          repostCount: data.repostCount,
        ),
        Divider(
          height: 0,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        PostActionBar(),
      ],
    );
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.imageURL,
    required this.username,
    required this.affiliation,
  });
  final String imageURL;
  final String username;
  final String affiliation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProfileImage(imageURL: imageURL),
        Expanded(
          flex: 9,
          child: UserInfo(
            username: username,
            affiliation: affiliation,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: GestureDetector(
            onTap: () => {UnimplementedError()},
            child: RichText(
              text: TextSpan(
                  style: TextStyle(color: ColorsManager.darkBurgundy),
                  children: [TextSpan(text: "+ Linc")]),
            ),
          ),
        )
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.username,
    required this.affiliation,
  });

  final String username;
  final String affiliation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: TextStyle(
            fontWeight: FontWeightHelper.extraBold,
          ),
        ),
        Text(
          affiliation,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeightHelper.extraLight,
          ),
        ),
      ],
    );
  }
}

class PostBody extends StatefulWidget {
  const PostBody({super.key, required this.text});
  final String text;

  @override
  State<PostBody> createState() => _PostBodyState();
}

class _PostBodyState extends State<PostBody> {
  bool _expandText = false;

  @override
  Widget build(BuildContext context) {
    //? might improve the UI for the "more" used at the end of the paragraph
    return Wrap(children: [
      Text(
        widget.text,
        maxLines: (_expandText) ? (null) : (3),
        overflow: (_expandText) ? (null) : (TextOverflow.ellipsis),
        softWrap: true,
      ),
      _expandText
          ? SizedBox()
          : GestureDetector(
              onTap: () {
                setState(() {
                  _expandText = true;
                });
              },
              child: Text(
                "more",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ),
            )
    ]);
  }
}

class PostNumerics extends StatelessWidget {
  const PostNumerics({
    super.key,
    required this.likesCount,
    required this.commentCount,
    required this.repostCount,
  });

  final int likesCount;
  final int commentCount;
  final int repostCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(likesCount.toString()),
          Spacer(),
          (commentCount == 0)
              ? SizedBox()
              : Text(
                  "$commentCount comment${(commentCount == 1) ? ("") : ("s")}"),
          (repostCount == 0 || commentCount == 0) ? SizedBox() : Text(" • "),
          (repostCount == 0)
              ? SizedBox()
              : Text("$repostCount repost${(repostCount == 1) ? ("") : ("s")}"),
        ],
      ),
    );
  }
}

class PostActionBar extends StatelessWidget {
  const PostActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //TODO Implement Buttons
          IconButton(
            onPressed: () => {UnimplementedError()},
            icon: Icon(Icons.thumb_up),
          ),
          IconButton(
            onPressed: () => {UnimplementedError()},
            icon: Icon(Icons.comment),
          ),
          IconButton(
            onPressed: () => {UnimplementedError()},
            icon: Icon(Icons.loop),
          ),
          IconButton(
            onPressed: () => {UnimplementedError()},
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class PostAttachments extends StatelessWidget {
  final List<String> attachmentURLs;

  const PostAttachments({super.key, required this.attachmentURLs});

  @override
  Widget build(BuildContext context) {
    //TODO this needs revising
    // return FadeInImage.memoryNetwork(
    //   placeholder: kTransparentImage,
    //   image: attachmentURL,spaceAround
    // );
    return Image.network(attachmentURLs[0]);
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.imageURL});
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    //TODO this needs revising
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
    );
  }
}
