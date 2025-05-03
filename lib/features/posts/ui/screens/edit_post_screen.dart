import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joblinc/core/helpers/user_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/logic/cubit/edit_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/edit_post_state.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel post;

  const EditPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _inputController;
  late List<PostmediaModel> _mediaItems;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: widget.post.text);
    _mediaItems = List.from(widget.post.attachmentURLs);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditPostCubit, EditPostState>(
      listener: (context, state) {
        if (state is EditPostSuccess) {
          CustomSnackBar.show(
            context: context,
            message: 'Post updated successfully',
            type: SnackBarType.success,
          );
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is EditPostFailure) {
          CustomSnackBar.show(
            context: context,
            message: state.error,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LoadingIndicatorOverlay(
              inAsyncCall: state is EditPostLoading,
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      autofocus: true,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: 'Edit your post...',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(),
                      showCursor: true,
                      cursorColor: Colors.black,
                    ),
                  ),
                  // Display current media
                  if (_mediaItems.isNotEmpty)
                    Container(
                      height: 100,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _mediaItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                Image.network(
                                  _mediaItems[index].url,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.close, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _mediaItems.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          List<XFile> medias = await picker.pickMultipleMedia();
                          // TODO: Implement media upload and add URLs to _mediaItems
                        },
                        icon: Icon(Icons.image),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          FutureBuilder(
            future: UserService.getProfilePicture(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ProfileImage(imageURL: snapshot.data);
              } else {
                return ProfileImage(imageURL: null);
              }
            },
          ),
          SizedBox(width: 8),
          Text(
            "Edit Post",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              foregroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              textStyle: TextStyle(fontWeight: FontWeightHelper.semiBold),
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey,
            ),
            onPressed: _inputController.text.isNotEmpty
                ? () {
                    context.read<EditPostCubit>().editPost(
                          widget.post.postID,
                          _inputController.text,
                          _mediaItems,
                        );
                  }
                : null,
            child: Text('Save'),
          ),
        ),
      ],
    );
  }
}
