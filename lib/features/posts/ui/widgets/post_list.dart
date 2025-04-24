import 'package:flutter/material.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/ui/widgets/post_widget.dart';

class PostList extends StatelessWidget {
  const PostList({super.key, required this.posts});
  final List<PostModel> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) => Post(data: posts[index]),
    );
  }
}
