import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/posts/logic/cubit/focus_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/focus_post_state.dart';
import 'package:joblinc/features/posts/ui/widgets/post_widget.dart';

class FocusPostScreen extends StatelessWidget {
  final String postId;
  
  const FocusPostScreen({Key? key, required this.postId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FocusPostCubit>()..loadPost(postId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post'),
          elevation: 0,
        ),
        body: BlocBuilder<FocusPostCubit, FocusPostState>(
          builder: (context, state) {
            if (state is FocusPostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FocusPostLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Post(
                    data: state.post,
                    showExtraMenu: true,
                  ),
                ),
              );
            } else if (state is FocusPostError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text('Error: ${state.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FocusPostCubit>().loadPost(postId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Loading post...'));
            }
          },
        ),
      ),
    );
  }
}
