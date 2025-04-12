import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_styles.dart';
import 'package:joblinc/features/posts/logic/cubit/post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/post_state.dart';
import 'package:joblinc/features/posts/ui/widgets/comment_section.dart';
import 'package:joblinc/features/posts/ui/widgets/user_header.dart';
import '../../data/models/post_model.dart';

class Post extends StatelessWidget {
  //this would need to be changed to support live updates to likes/comments/reposts
  const Post({super.key, required this.data});
  final PostModel data;

  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => getIt<PostCubit>(),
      child: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostStateLoading) {
          } else if (state is PostStateSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Post successful')));
            Navigator.pop(context);
          } else if (state is PostStateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              "Error: ${state.error}",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )));
          }
        },
        builder: (context, state) => Padding(
          key: Key('post_main_container'),
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            color: ColorsManager.getCardColor(context),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: PostContent(data: data),
            ),
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
              key: Key('post_header_lincButton'),
              onTap: () => {
                // context.read<UserConnectionsRepository>()
              },
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: ColorsManager.getPrimaryColor(context)),
                    children: [
                      TextSpan(
                        text: data.isCompany ? '+ Follow' : '+ Linc',
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
          color: ColorsManager.getTextSecondary(context),
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
    return Wrap(
      key: Key('post_body_container'),
      children: [
        Text(
          key: Key('post_body_text'),
          widget.text,
          maxLines: (_expandText) ? (null) : (3),
          overflow: (_expandText) ? (null) : (TextOverflow.ellipsis),
          softWrap: true,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
        ),
        _expandText
            ? SizedBox()
            : GestureDetector(
                key: Key('post_body_showMoreButton'),
                onTap: () {
                  setState(() {
                    _expandText = true;
                  });
                },
                child: Text(
                  'more',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.getTextPrimary(context),
                  ),
                ),
              )
      ],
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
      child: Row(
        key: Key('post_numerics_container'),
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.thumb_up,
            size: 15,
            color: ColorsManager.getTextSecondary(context),
          ),
          Text(
            key: Key('post_numerics_likeCount'),
            ' ${likesCount.toString()}',
            style: TextStyles.font13GrayRegular(context),
          ),
          Spacer(),
          (commentCount == 0)
              ? SizedBox()
              : Text(
                  key: Key('post_numerics_commentCount'),
                  '$commentCount comment${(commentCount == 1) ? ('') : ('s')}',
                  style: TextStyles.font13GrayRegular(context),
                ),
          (repostCount == 0 || commentCount == 0)
              ? SizedBox()
              : Text(' • ', style: TextStyles.font13GrayRegular(context)),
          (repostCount == 0)
              ? SizedBox()
              : Text(
                  key: Key('post_numerics_repostCount'),
                  '$repostCount repost${(repostCount == 1) ? ('') : ('s')}',
                  style: TextStyles.font13GrayRegular(context),
                ),
        ],
      ),
    );
  }
}

class PostActionBar extends StatelessWidget {
  const PostActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = ColorsManager.getTextSecondary(context);

    return Padding(
      key: Key('post_actionaBar_container'),
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //TODO Implement Buttons
          IconButton(
            key: Key('post_actionBar_like'),
            onPressed: () => {UnimplementedError()},
            icon: Icon(Icons.thumb_up, color: iconColor),
          ),
          IconButton(
            key: Key('post_actionBar_comment'),
            onPressed: () => {
              showModalBottomSheet(
                  showDragHandle: true,
                  scrollControlDisabledMaxHeightRatio: 0.9,
                  context: context,
                  builder: (context) {
                    return CommentSection();
                  })
            },
            icon: Icon(Icons.comment, color: iconColor),
          ),
          IconButton(
            key: Key('post_actionBar_repost'),
            onPressed: () => {UnimplementedError()},
            icon: Icon(Icons.loop, color: iconColor),
          ),
          IconButton(
            key: Key('post_actionBar_share'),
            onPressed: () => {UnimplementedError()},
            icon: Icon(Icons.send, color: iconColor),
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
      key: Key('post_body_attachments'),
      attachmentURLs[0],
    );
  }
}
