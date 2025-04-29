import 'package:flutter/material.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/ui/widgets/post_widget.dart';

class PostList extends StatelessWidget {
  const PostList({
    super.key,
    required this.posts,
    this.showExtraMenu = true,
    this.showOwnerMenu = false,
  });
  final List<PostModel> posts;
  final bool showExtraMenu;
  final bool showOwnerMenu;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 2000,
      itemCount: posts.length,
      itemBuilder: (context, index) => Post(
        data: posts[index],
        showExtraMenu: showExtraMenu,
        showOwnerMenu: showOwnerMenu,
      ),
    );
  }
}
