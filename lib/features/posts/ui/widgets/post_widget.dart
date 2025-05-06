import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_styles.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/data/services/tag_suggestion_service.dart';
import 'package:joblinc/features/posts/logic/cubit/edit_post_cubit.dart';
import 'package:joblinc/features/posts/data/models/reaction_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/logic/cubit/post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/post_state.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';
import 'package:joblinc/features/posts/ui/screens/edit_post_screen.dart';
import 'package:joblinc/features/posts/ui/widgets/comment_section.dart';
import 'package:joblinc/features/posts/ui/widgets/post_reactions.dart';
import 'package:joblinc/features/posts/ui/widgets/user_header.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mailer/mailer.dart';
import 'package:readmore/readmore.dart';
import '../../data/models/post_model.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.data,
    this.isSaved = false,
    this.showActionBar = true,
    this.showExtraMenu = true,
    this.showRepost = true,
    this.showOwnerMenu = false,
  });
  final PostModel data;
  final bool showRepost;
  final bool isSaved;
  final bool showActionBar;
  final bool showExtraMenu;
  final bool showOwnerMenu;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> likeCount = ValueNotifier(data.likeCount);
    return BlocProvider<PostCubit>(
      create: (context) => getIt<PostCubit>()..setPostId(data.postID),
      child: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostStateSuccess) {
            CustomSnackBar.show(
              context: context,
              message: state.successMessage,
              type: SnackBarType.success,
            );
          } else if (state is PostStateCommentsLoaded) {
            showCommentSectionBottomSheet(context, data.postID, state.comments)
                .whenComplete(context.read<PostCubit>().closeComments);
          } else if (state is PostStateFailure) {
            CustomSnackBar.show(
              context: context,
              message: state.error,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) => Container(
          color: ColorsManager.getCardColor(context),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: PostContent(
              state: state,
              data: data,
              isSaved: isSaved,
              showRepost: showRepost,
              showActionBar: showActionBar,
              showExtraMenu: showExtraMenu,
              showOwnerMenu: showOwnerMenu,
              likeCount: likeCount,
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
    required this.state,
    required this.data,
    required this.isSaved,
    required this.showRepost,
    required this.showActionBar,
    required this.showExtraMenu,
    required this.showOwnerMenu,
    required this.likeCount,
  });
  final PostState state;
  final PostModel data;
  final bool isSaved;
  final bool showRepost;
  final bool showActionBar;
  final bool showExtraMenu;
  final bool showOwnerMenu;
  final ValueNotifier<int> likeCount;

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
          senderID: data.senderID,
          isCompany: data.isCompany,
          timestamp: data.timeStamp,
          action: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Row(
              spacing: 10,
              children: [
                showExtraMenu
                    ? IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          showPostSettings(context, data.senderID,
                              showOwnerMenu, isSaved, data);
                        },
                        icon: Icon(Icons.more_vert),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: PostBody(
            text: data.text,
            taggedUsers: data.taggedUsers,
            taggedCompanies: data.taggedCompanies,
          ),
        ),
        data.repost == null || !showRepost
            ? (data.attachmentURLs.isNotEmpty
                ? PostAttachments(attachments: data.attachmentURLs)
                : SizedBox())
            : Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  child: Post(
                    data: data.repost!,
                    showRepost: false,
                    showActionBar: false,
                    showExtraMenu: false,
                  ),
                ),
              ),
        PostNumerics(
          postId: data.postID,
          likesCount: likeCount,
          commentCount: data.commentCount,
          repostCount: data.repostCount,
        ),
        showActionBar
            ? Divider(
                height: 0,
                color: ColorsManager.getTextSecondary(context),
              )
            : SizedBox(),
        showActionBar
            ? PostActionBar(
                data: data,
                state: state,
                userReaction: data.userReaction,
                likeCount: likeCount,
              )
            : SizedBox(),
      ],
    );
  }
}

class PostBody extends StatelessWidget {
  const PostBody({
    super.key,
    required this.text,
    this.taggedUsers = const [],
    this.taggedCompanies = const [],
  });

  final String text;
  final List<TaggedEntity> taggedUsers;
  final List<TaggedEntity> taggedCompanies;

  @override
  Widget build(BuildContext context) {
    if (taggedUsers.isEmpty && taggedCompanies.isEmpty) {
      return ReadMoreText(
        text,
        trimLines: 3,
        trimCollapsedText: "more",
        trimExpandedText: " show less",
        trimMode: TrimMode.Line,
        style: TextStyle(
          color: ColorsManager.getTextPrimary(context),
        ),
      );
    }

    return ExpandableRichText(
      text: text,
      taggedUsers: taggedUsers,
      taggedCompanies: taggedCompanies,
      trimLines: 3,
      context: context,
    );
  }
}

class ExpandableRichText extends StatefulWidget {
  const ExpandableRichText({
    Key? key,
    required this.text,
    required this.taggedUsers,
    required this.taggedCompanies,
    required this.trimLines,
    required this.context,
  }) : super(key: key);

  final String text;
  final List<TaggedEntity> taggedUsers;
  final List<TaggedEntity> taggedCompanies;
  final int trimLines;
  final BuildContext context;

  @override
  _ExpandableRichTextState createState() => _ExpandableRichTextState();
}

class _ExpandableRichTextState extends State<ExpandableRichText> {
  bool _isExpanded = false;
  late Future<TextSpan> _textSpanFuture;

  @override
  void initState() {
    super.initState();
    _textSpanFuture = _buildTextSpanAsync(widget.context);
  }

  Future<TextSpan> _buildTextSpanAsync(BuildContext context) async {
    List<TaggedEntity> taggedUsers = [
      ...widget.taggedUsers,
    ];
    List<TaggedEntity> taggedCompanies = [
      ...widget.taggedCompanies,
    ];

    taggedUsers.sort((a, b) => a.index.compareTo(b.index));
    taggedCompanies.sort((a, b) => a.index.compareTo(b.index));

    if (taggedUsers.isEmpty && taggedCompanies.isEmpty) {
      return TextSpan(
        text: widget.text,
        style: TextStyle(color: ColorsManager.getTextPrimary(context)),
      );
    }

    List<TextSpan> spans = [];
    int lastIndex = 0;
    final TagSuggestionService tagSuggestionService =
        getIt<TagSuggestionService>();

    // Fetch all tag names first
    Map<String, String> tagNames = {};
    for (var tag in taggedUsers) {
      try {
        String? name = await tagSuggestionService.getUserName(tag.id);
        tagNames[tag.id] = name ?? '%taggedUsed';
      } catch (e) {
        // Fallback to ID if name fetch fails
        tagNames[tag.id] = tag.id;
      }
    }

    for (var tag in taggedCompanies) {
      try {
        String? name = await tagSuggestionService.getCompanyName(tag.id);
        tagNames[tag.id] = name ?? '%taggedCompany';
      } catch (e) {
        // Fallback to ID if name fetch fails
        tagNames[tag.id] = tag.id;
      }
    }
    // Now build spans with the fetched names
    for (var tag in taggedUsers) {
      String tagName;
      if (tagNames.containsKey(tag.id)) {
        tagName = tagNames[tag.id]!;
      } else {
        tagName = tag is TaggedCompany ? tag.name : tag.id;
      }
      String tagText = '@$tagName';
      int tagIndex = tag.index;

      if (tagIndex >= 0 && tagIndex < widget.text.length) {
        if (tagIndex > lastIndex) {
          spans.add(TextSpan(
            text: widget.text.substring(lastIndex, tagIndex),
            style: TextStyle(color: ColorsManager.getTextPrimary(context)),
          ));
        }

        spans.add(TextSpan(
          text: tagText,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _handleTagTap(context, tag);
            },
        ));

        lastIndex = tagIndex + tagText.length;
      }
    }

    for (var tag in taggedCompanies) {
      String tagName;
      if (tagNames.containsKey(tag.id)) {
        tagName = tagNames[tag.id]!;
      } else {
        tagName = tag is TaggedCompany ? tag.name : tag.id;
      }
      String tagText = '@$tagName';
      int tagIndex = tag.index;

      if (tagIndex >= 0 && tagIndex < widget.text.length) {
        if (tagIndex > lastIndex) {
          spans.add(TextSpan(
            text: widget.text.substring(lastIndex, tagIndex),
            style: TextStyle(color: ColorsManager.getTextPrimary(context)),
          ));
        }

        spans.add(TextSpan(
          text: tagText,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushNamed(
                context,
                Routes.companyPageHome,
                arguments: tag.id,
              );
            },
        ));

        lastIndex = tagIndex + tagText.length;
      }
    }

    // Add any remaining text after the last tag
    if (lastIndex < widget.text.length) {
      spans.add(TextSpan(
        text: widget.text.substring(lastIndex),
        style: TextStyle(color: ColorsManager.getTextPrimary(context)),
      ));
    }

    return TextSpan(children: spans);
  }

  void _handleTagTap(BuildContext context, TaggedEntity tag) async {
    if (tag is TaggedUser) {
      Navigator.pushNamed(
        context,
        Routes.otherProfileScreen,
        arguments: tag.id,
      );
    } else if (tag is TaggedCompany) {
      Navigator.pushNamed(
        context,
        Routes.companyPageHome,
        arguments: tag.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TextSpan>(
      future: _textSpanFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error loading post content');
        } else if (!snapshot.hasData) {
          return Text(widget.text);
        }

        TextSpan textSpan = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: textSpan,
              maxLines: _isExpanded ? null : widget.trimLines,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (!_isExpanded && _isTextOverflowing(context, textSpan))
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = true;
                  });
                },
                child: Text(
                  "more",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            if (_isExpanded)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
                child: Text(
                  "show less",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
        );
      },
    );
  }

  bool _isTextOverflowing(BuildContext context, TextSpan textSpan) {
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 32);

    return textPainter.didExceedMaxLines;
  }
}

class PostNumerics extends StatelessWidget {
  const PostNumerics({
    super.key,
    required this.postId,
    required this.likesCount,
    required this.commentCount,
    required this.repostCount,
  });
  final String postId;
  final ValueNotifier<int> likesCount;
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
          GestureDetector(
            onTap: () async {
              // try {
              //   final List<ReactionModel> reactions =
              //       await getIt.get<PostRepo>().getPostReactions(postId);
              //   if (context.mounted) {
              //     showModalBottomSheet(
              //       context: context,
              //       showDragHandle: true,
              //       builder: (context) => PostReactions(reactions: reactions),
              //     );
              //   }
              // } on Exception catch (e) {
              //   if (context.mounted) {
              //     CustomSnackBar.show(
              //       context: context,
              //       message: e.toString(),
              //       type: SnackBarType.error,
              //     );
              //   }
              //   return;
              // }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.thumbsUp,
                  size: 15,
                  color: ColorsManager.getTextSecondary(context),
                ),
                ValueListenableBuilder(
                  valueListenable: likesCount,
                  builder: (context, value, child) => Text(
                    key: Key('post_numerics_likeCount'),
                    ' $value',
                    style: TextStyles.font13GrayRegular(context),
                  ),
                ),
              ],
            ),
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
  const PostActionBar({
    super.key,
    required this.data,
    required this.state,
    required this.likeCount,
    required this.userReaction,
  });
  final PostModel data;
  final PostState state;
  final ValueNotifier<int> likeCount;
  final Reactions? userReaction;

  @override
  Widget build(BuildContext context) {
    final initialLikeCount = likeCount.value;
    final iconColor = ColorsManager.getTextSecondary(context);

    return Padding(
      key: Key('post_actionaBar_container'),
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PostReactionButton(
              userReaction: userReaction,
              initialLikeCount: initialLikeCount,
              likeCount: likeCount),
          IconButton(
            key: Key('post_actionBar_comment'),
            onPressed: () {
              if (state is! PostStateCommentsLoaded &&
                  state is! PostStateCommentsLoading) {
                context.read<PostCubit>().getComments();
              }
            },
            icon: Icon(Icons.comment, color: iconColor),
          ),
          IconButton(
            key: Key('post_actionBar_repost'),
            onPressed: () => {
              Navigator.pushNamed(context, Routes.addPostScreen,
                  arguments: data.repost ?? data)
            },
            icon: Icon(Icons.loop, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class PostReactionButton extends StatelessWidget {
  const PostReactionButton({
    super.key,
    required this.userReaction,
    required this.initialLikeCount,
    required this.likeCount,
  });

  final Reactions? userReaction;
  final int initialLikeCount;
  final ValueNotifier<int> likeCount;

  @override
  Widget build(BuildContext context) {
    return ReactionButton(
        onReactionChanged: (item) {
          if (item?.value != null) {
            context.read<PostCubit>().reactToPost((item?.value)!);
            if (userReaction == null && initialLikeCount == likeCount.value) {
              likeCount.value++;
            }
          }
        },
        isChecked: userReaction != null,
        selectedReaction: getReaction(userReaction),
        itemsSpacing: 10,
        toggle: false,
        placeholder: Reaction(
          value: null,
          icon: Icon(
            LucideIcons.smilePlus,
          ),
        ),
        reactions: [
          Reaction(
            value: Reactions.like,
            icon: Icon(
              LucideIcons.thumbsUp,
              color: Colors.blue,
            ),
          ),
          Reaction(
            value: Reactions.celebrate,
            icon: Icon(
              LucideIcons.partyPopper,
              color: Colors.pink,
            ),
          ),
          Reaction(
            value: Reactions.support,
            icon: Icon(
              LucideIcons.helpingHand,
              color: Colors.green.shade600,
            ),
          ),
          Reaction(
            value: Reactions.funny,
            icon: Icon(
              LucideIcons.laugh,
              color: Colors.purple.shade600,
            ),
          ),
          Reaction(
            value: Reactions.love,
            icon: Icon(
              LucideIcons.heart,
              color: Colors.red.shade600,
            ),
          ),
          Reaction(
            value: Reactions.insightful,
            icon: Icon(
              LucideIcons.lightbulb,
              color: Colors.yellow.shade600,
            ),
          ),
        ],
        itemSize: Size(24, 24));
  }
}

class PostAttachments extends StatelessWidget {
  final List<PostmediaModel> attachments;

  const PostAttachments({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    //TODO handle multiple images
    for (var attachment in attachments) {
      if (attachment.mediaType == PostMediaType.image) {
        return Image.network(
          errorBuilder: (context, error, stackTrace) => SizedBox(),
          key: Key('post_body_attachments'),
          attachment.url,
        );
      }
    }
    return SizedBox();
    // return Expanded(child: MultimediaHandler(mediaItem: attachments[0]));
    // return buildMultipleMediaGrid(attachments);
  }
}

Future<dynamic> showPostSettings(BuildContext context, String userId,
    bool showOwnerMenu, bool isSaved, PostModel data) {
  List<Widget> postSettingsNormalButtons = [
    isSaved
        ? ListTile(
            leading: Icon(Icons.bookmark_remove_outlined),
            title: Text('Unsave post'),
            onTap: () {
              context.read<PostCubit>().unsavePost();
              Navigator.pop(context);
            },
          )
        : ListTile(
            leading: Icon(Icons.bookmark_add_outlined),
            title: Text('Save post'),
            onTap: () {
              context.read<PostCubit>().savePost();
              Navigator.pop(context);
            },
          ),
    ListTile(
      leading: Icon(Icons.flag_outlined),
      title: Text('Report post'),
      onTap: () {
        context.read<PostCubit>().reportPost();
        Navigator.pop(context);
      },
    ),
    ListTile(
      leading: Icon(Icons.person_off_outlined),
      title: Text('Block user'),
      onTap: () {
        context.read<PostCubit>().blockUser(userId);
        Navigator.pop(context);
      },
    ),
  ];

  List<Widget> postSettingsOwnerButtons = [
    ListTile(
      leading: Icon(Icons.edit_outlined),
      title: Text('Edit post'),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => getIt<EditPostCubit>(),
              child: EditPostScreen(post: data),
            ),
          ),
        );
      },
    ),
    ListTile(
      leading: Icon(Icons.delete_outline),
      title: Text('Delete post'),
      onTap: () {
        context.read<PostCubit>().deletePost();
        Navigator.pop(context);
      },
    ),
  ];
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: showOwnerMenu
              ? postSettingsOwnerButtons
              : postSettingsNormalButtons),
    ),
  );
}
