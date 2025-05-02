import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/posts/logic/cubit/saved_posts_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/saved_posts_state.dart';
import 'package:joblinc/features/posts/ui/widgets/post_list.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPostsCubit, SavedPostsState>(
      builder: (context, state) => Scaffold(
        appBar: buildAppBar(),
        body: LoadingIndicatorOverlay(
          inAsyncCall: state is SavedPostsLoading,
          child: state is SavedPostsLoaded
              ? PostList(
                  posts: state.posts,
                  isSaved: true,
                )
              : state is SavedPostsFailure
                  ? Center(
                      child: Text('There was an error loading you posts'),
                    )
                  : SizedBox(),
        ),
      ),
    );
  }

  AppBar buildAppBar() => AppBar(
        title: Text('Saved Posts'),
        elevation: 1,
      );
}
