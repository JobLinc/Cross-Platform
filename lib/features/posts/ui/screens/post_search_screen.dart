import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/posts/logic/cubit/post_search_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/post_search_state.dart';
import 'package:joblinc/features/posts/ui/widgets/post_list.dart';

class PostSearchScreen extends StatefulWidget {
  const PostSearchScreen({Key? key}) : super(key: key);

  @override
  State<PostSearchScreen> createState() => _PostSearchScreenState();
}

class _PostSearchScreenState extends State<PostSearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Search'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<PostSearchCubit>().resetSearch();
                  },
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? ColorsManager.lightGray
                    : ColorsManager.darkModeCardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<PostSearchCubit>().searchPosts(value);
                }
              },
            ),
          ),
        ),
      ),
      body: BlocConsumer<PostSearchCubit, PostSearchState>(
        listener: (context, state) {
          if (state is PostSearchError) {
            CustomSnackBar.show(
              context: context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          return LoadingIndicatorOverlay(
            inAsyncCall: state is PostSearchLoading,
            child: _buildContent(state),
          );
        },
      ),
    );
  }

  Widget _buildContent(PostSearchState state) {
    if (state is PostSearchInitial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              'Search for posts',
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    } else if (state is PostSearchLoaded) {
      if (state.posts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64.sp,
                color: Colors.grey,
              ),
              SizedBox(height: 16.h),
              Text(
                'No posts found for "${state.searchTerm}"',
                style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return PostList(
        posts: state.posts,
        showOwnerMenu: false,
      );
    }

    // Error state or other states
    return SizedBox.shrink();
  }
}
