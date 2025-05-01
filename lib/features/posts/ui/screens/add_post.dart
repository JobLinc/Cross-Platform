import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_state.dart';
import 'package:joblinc/features/posts/ui/widgets/post_widget.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key, this.repost});
  PostModel? repost;
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<String>> mediaUrls = ValueNotifier([]);
    return BlocConsumer<AddPostCubit, AddPostState>(
      listener: (context, state) {
        if (state is AddPostStateLoading) {
        } else if (state is AddPostStateSuccess) {
          CustomSnackBar.show(
            context: context,
            message: 'Post successful',
            type: SnackBarType.success,
          );
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is AddPostStateFailure) {
          CustomSnackBar.show(
            context: context,
            message: state.error,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: addPostTopBar(context, _inputController, repost?.postID),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 20.0,
            ),
            child: LoadingIndicatorOverlay(
              inAsyncCall: state is AddPostStateLoading,
              child: Column(
                children: repost == null
                    ? ([
                        Flexible(
                          child: TextField(
                            controller: _inputController,
                            autofocus: true,
                            maxLines: null,
                            expands: true,
                            onChanged: (text) => {if (text == '') {} else {}},
                            decoration: InputDecoration(
                              hintText: 'Share your thoughts...',
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(),
                            showCursor: true,
                            cursorColor: Colors.black,
                          ),
                        ),
                        BottomButtons(
                          mediaUrls: mediaUrls,
                        )
                      ])
                    : [
                        Flexible(
                          child: TextField(
                            controller: _inputController,
                            autofocus: true,
                            maxLines: null,
                            expands: false,
                            onChanged: (text) => {if (text == '') {} else {}},
                            decoration: InputDecoration(
                              hintText: 'Share your thoughts...',
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(),
                            showCursor: true,
                            cursorColor: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: Post(
                              data: repost!,
                              showRepost: false,
                              showActionBar: false,
                              showExtraMenu: false,
                            ),
                          ),
                        ),
                      ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
    required this.mediaUrls,
  });
  final ValueNotifier<List<String>> mediaUrls;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () async {
              //TODO use the media
              final picker = ImagePicker();
              List<XFile> medias = await picker.pickMultipleMedia();
            },
            icon: Icon(Icons.image)),
      ],
    );
  }
}

AppBar addPostTopBar(BuildContext context,
    TextEditingController inputController, String? repostId) {
  bool isPublic;
  return AppBar(
    title: GestureDetector(
      onTap: () {
        showModalBottomSheet(
            showDragHandle: true,
            context: context,
            builder: (context) {
              return PrivacySettings();
            });
      },
      child: Row(
        spacing: 8,
        children: [
          CircleAvatar(
            radius: 20,
          ),
          Text(
            "Anyone",
            style: TextStyle(fontSize: 20),
          ),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: inputController,
            builder: (context, value, child) {
              return TextButton(
                style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    textStyle: TextStyle(fontWeight: FontWeightHelper.semiBold),
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey),
                onPressed: value.text.isNotEmpty
                    ? () {
                        context
                            .read<AddPostCubit>()
                            .addPost(value.text, [], repostId, true);
                      }
                    : null,
                child: Text('Post'),
              );
            }),
      )
    ],
  );
}

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => PrivacySettingsState();
}

class PrivacySettingsState extends State<PrivacySettings> {
  late bool isPublic;

  @override
  void initState() {
    super.initState();
    isPublic = true;
  }

  void _updateSelectedValue(bool? value) {
    if (value != null) {
      setState(() {
        isPublic = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Who can see your post?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
          ),
          ListTile(
            leading: Radio(
                value: true,
                groupValue: isPublic,
                onChanged: _updateSelectedValue),
            title: Text(
              'Public',
              style: TextStyle(fontWeight: FontWeightHelper.semiBold),
            ),
            subtitle: Text(
              'Anyone can see your post',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            onTap: () => _updateSelectedValue(true),
          ),
          ListTile(
            leading: Radio(
                value: false,
                groupValue: isPublic,
                onChanged: _updateSelectedValue),
            title: Text(
              'Connections only',
              style: TextStyle(fontWeight: FontWeightHelper.semiBold),
            ),
            subtitle: Text(
              'Only connections can see your post',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            onTap: () => _updateSelectedValue(false),
          ),
        ],
      ),
    );
  }
}
