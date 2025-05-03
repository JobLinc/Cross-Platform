import 'package:flutter/material.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/ui/widgets/post_widget.dart';

class PostList extends StatelessWidget {
  const PostList({
    super.key,
    required this.posts,
    this.invertScrollDirection = false,
    this.isSaved = false,
    this.showExtraMenu = true,
    this.showOwnerMenu = false,
  });
  final List<PostModel> posts;
  final bool invertScrollDirection;
  final bool isSaved;
  final bool showExtraMenu;
  final bool showOwnerMenu;

  @override
  Widget build(BuildContext context) {
    if (posts.isNotEmpty) {
      return ListView.builder(
        scrollDirection:
            invertScrollDirection ? Axis.horizontal : Axis.vertical,
        cacheExtent: 2000,
        itemCount: posts.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Post(
            data: posts[index],
            isSaved: isSaved,
            showExtraMenu: showExtraMenu,
            showOwnerMenu: showOwnerMenu,
          ),
        ),
      );
    } else {
      return Center(
        child: Text('No posts yet'),
      );
    }
  }
}
