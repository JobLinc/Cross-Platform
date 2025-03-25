import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/posts/ui/widgets/comment_section.dart';
import 'package:joblinc/features/posts/ui/widgets/user_header.dart';
import '../../data/models/post_model.dart';

class Post extends StatelessWidget {
  //this will need to be changed to support live updates to likes/comments/reposts
  const Post({super.key, required this.data});
  final PostModel data;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'post_main_container',
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: PostContent(data: data),
          ),
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
        UserHeader(
          imageURL: data.profilePictureURL,
          username: data.username,
          headline: data.headline,
          action: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: GestureDetector(
              onTap: () => {UnimplementedError()},
              child: RichText(
                text: TextSpan(
                    style: TextStyle(color: ColorsManager.darkBurgundy),
                    children: [
                      TextSpan(
                        text: '+ Linc',
                        semanticsLabel: 'post_header_lincButton',
                      )
                    ]),
              ),
            ),
          ),
        ),
        PostBody(
          text: data.text,
        ),
        data.attachmentURLs.isNotEmpty
            ? PostAttachments(attachmentURLs: data.attachmentURLs)
            : SizedBox(),
        PostNumerics(
          likesCount: data.likeCount,
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
    //? might improve the UI for the 'more' used at the end of the paragraph
    return Semantics(
      container: true,
      label: 'post_body_container',
      child: Wrap(children: [
        Text(
          widget.text,
          maxLines: (_expandText) ? (null) : (3),
          overflow: (_expandText) ? (null) : (TextOverflow.ellipsis),
          softWrap: true,
          semanticsLabel: 'post_body_text',
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
                  'more',
                  semanticsLabel: 'post_body_showMoreButton',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                ),
              )
      ]),
    );
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
      child: Semantics(
        container: true,
        label: 'post_numerics_container',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.thumb_up,
              size: 15,
            ),
            Text(
              ' ${likesCount.toString()}',
              semanticsLabel: 'post_numerics_likeCount',
            ),
            Spacer(),
            (commentCount == 0)
                ? SizedBox()
                : Text(
                    '$commentCount comment${(commentCount == 1) ? ('') : ('s')}',
                    semanticsLabel: 'post_numerics_commentCount',
                  ),
            (repostCount == 0 || commentCount == 0) ? SizedBox() : Text(' • '),
            (repostCount == 0)
                ? SizedBox()
                : Text(
                    '$repostCount repost${(repostCount == 1) ? ('') : ('s')}',
                    semanticsLabel: 'post_numerics_repostCount',
                  ),
          ],
        ),
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
          Semantics(
            label: 'post_actionBar_like',
            child: IconButton(
              onPressed: () => {UnimplementedError()},
              icon: Icon(Icons.thumb_up),
            ),
          ),
          Semantics(
            label: 'post_actionBar_comment',
            child: IconButton(
              onPressed: () => {
                showModalBottomSheet(
                    showDragHandle: true,
                    scrollControlDisabledMaxHeightRatio: 0.9,
                    context: context,
                    builder: (context) {
                      return CommentSection();
                    })
              },
              icon: Icon(Icons.comment),
            ),
          ),
          Semantics(
            label: 'post_actionBar_repost',
            child: IconButton(
              onPressed: () => {UnimplementedError()},
              icon: Icon(Icons.loop),
            ),
          ),
          Semantics(
            label: 'post_actionBar_share',
            child: IconButton(
              onPressed: () => {UnimplementedError()},
              icon: Icon(Icons.send),
            ),
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
    return Image.network(
      attachmentURLs[0],
      semanticLabel: 'post_body_attachments',
    );
  }
}
