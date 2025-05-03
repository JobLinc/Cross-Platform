import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/user_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_state.dart';
import 'package:joblinc/features/posts/ui/widgets/image_upload.dart';
import 'package:joblinc/features/posts/ui/widgets/post_widget.dart';
import 'package:joblinc/features/posts/ui/widgets/tagged_text_controller.dart';

class AddPostScreen extends StatefulWidget {
  final PostModel? repost;

  const AddPostScreen({super.key, this.repost});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late TaggedTextEditingController _inputController;
  final ValueNotifier<List<PostmediaModel>> mediaUrls = ValueNotifier([]);
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final ValueNotifier<bool> _isPublic = ValueNotifier(true);
  String _currentTagQuery = '';
  List<dynamic> _tagSuggestions = [];
  bool _isLoadingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _inputController = TaggedTextEditingController();
    _inputController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _inputController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    try {
      final text = _inputController.text;

      if (text.isNotEmpty && text.length > 1) {
        final previousChar = text[_inputController.selection.baseOffset - 1];
        if (previousChar == '@' && !_inputController.isTagging()) {
          _inputController.startTagging();
          _showTagSuggestions('');
          return;
        }
      }

      if (_inputController.isTagging()) {
        final tagText = _inputController.getCurrentTagText();

        if (tagText.contains(' ') || tagText.contains('\n')) {
          _removeOverlay();
          _inputController.stopTagging();
          return;
        }

        if (tagText != _currentTagQuery) {
          _currentTagQuery = tagText;
          _showTagSuggestions(tagText);
        }
      }
    } catch (e) {
      print("Error in _onTextChanged: $e");
    }
  }

  void _showTagSuggestions(String query) async {
    setState(() {
      _isLoadingSuggestions = true;
    });

    final tagIndex = _inputController.currentTagStartIndex!;

    List<TaggedUser> userSuggestions =
        await context.read<AddPostCubit>().getUserSuggestions(query);
    List<TaggedCompany> companySuggestions =
        await context.read<AddPostCubit>().getCompanySuggestions(query);

    setState(() {
      _tagSuggestions = [...userSuggestions, ...companySuggestions];
      _isLoadingSuggestions = false;
    });

    _removeOverlay();
    _buildTagOverlay();
  }

  void _buildTagOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: MediaQuery.of(context).size.width * 0.8,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, 50),
            child: Material(
              elevation: 4.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                constraints: BoxConstraints(
                  maxHeight: 200,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isLoadingSuggestions
                    ? Center(child: CircularProgressIndicator())
                    : _tagSuggestions.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('No suggestions found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _tagSuggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = _tagSuggestions[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  child: suggestion is TaggedUser
                                      ? Icon(Icons.person)
                                      : Icon(Icons.business),
                                ),
                                title: Text(
                                  suggestion is TaggedUser
                                      ? suggestion.name
                                      : suggestion.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(suggestion is TaggedUser
                                    ? 'User'
                                    : 'Company'),
                                onTap: () {
                                  if (suggestion is TaggedUser) {
                                    _inputController.addTaggedUser(
                                      suggestion,
                                      _inputController.currentTagStartIndex!,
                                    );
                                  } else if (suggestion is TaggedCompany) {
                                    _inputController.addTaggedCompany(
                                      suggestion,
                                      _inputController.currentTagStartIndex!,
                                    );
                                  }
                                  _removeOverlay();
                                },
                              );
                            },
                          ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<ImageUploadWidget>> uploadWidgets =
        ValueNotifier([]);

    return BlocConsumer<AddPostCubit, AddPostState>(
      listener: (context, state) {
        if (state is AddPostStateSuccess) {
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
          appBar: addPostTopBar(
            context,
            _inputController,
            widget.repost?.postID,
            mediaUrls,
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 20.0,
            ),
            child: LoadingIndicatorOverlay(
              inAsyncCall: state is AddPostStateLoading,
              child: Column(
                children: widget.repost == null
                    ? [
                        Flexible(
                          child: CompositedTransformTarget(
                            link: _layerLink,
                            child: TextField(
                              controller: _inputController,
                              autofocus: true,
                              maxLines: null,
                              expands: true,
                              decoration: InputDecoration(
                                hintText: 'Share your thoughts... Use @ to tag',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade600),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(),
                              showCursor: true,
                              cursorColor: Colors.black,
                            ),
                          ),
                        ),
                        BottomButtons(
                            mediaUrls: mediaUrls, uploadWidgets: uploadWidgets),
                      ]
                    : [
                        Flexible(
                          child: CompositedTransformTarget(
                            link: _layerLink,
                            child: TextField(
                              controller: _inputController,
                              autofocus: true,
                              maxLines: null,
                              expands: false,
                              decoration: InputDecoration(
                                hintText: 'Share your thoughts... Use @ to tag',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade600),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(),
                              showCursor: true,
                              cursorColor: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: Post(
                              data: widget.repost!,
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

class UploadedImagesBar extends StatelessWidget {
  const UploadedImagesBar({
    super.key,
    required this.uploadWidgets,
  });

  final ValueNotifier<List<ImageUploadWidget>> uploadWidgets;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: uploadWidgets,
      builder: (context, uploads, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: uploads,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
    required this.mediaUrls,
    required this.uploadWidgets,
  });
  final ValueNotifier<List<PostmediaModel>> mediaUrls;
  final ValueNotifier<List<ImageUploadWidget>> uploadWidgets;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () async {
              final picker = ImagePicker();
              List<XFile> medias = await picker.pickMultiImage();
              for (XFile media in medias) {
                final futureMedia = getIt.get<PostRepo>().uploadImage(media);
                futureMedia.then((media) => mediaUrls.value.add(media));
                uploadWidgets.value.add(
                  ImageUploadWidget(
                    imageWidget: Image.file(File(media.path)),
                    uploadFuture: futureMedia,
                  ),
                );
              }
            },
            icon: Icon(Icons.image)),
      ],
    );
  }
}

AppBar addPostTopBar(
  BuildContext context,
  TaggedTextEditingController inputController,
  String? repostId,
  ValueNotifier<List<PostmediaModel>> mediaUrls,
) {
  final ValueNotifier<bool> isPublic = ValueNotifier(true);
  return AppBar(
    title: GestureDetector(
      onTap: () {
        showModalBottomSheet(
          showDragHandle: true,
          context: context,
          builder: (context) {
            return PrivacySettings(
              isPublic: isPublic,
            );
          },
        );
      },
      child: Row(
        spacing: 8,
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
          ValueListenableBuilder(
            valueListenable: isPublic,
            builder: (context, value, child) => Text(
              value ? "Anyone" : "Connections only",
              style: TextStyle(fontSize: 20),
            ),
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
                disabledForegroundColor: Colors.grey,
              ),
              onPressed: value.text.isNotEmpty
                  ? () {
                      print(
                          'sending posts with media: ${mediaUrls.value.isNotEmpty ? mediaUrls.value[0].url : 'None'}');
                      context.read<AddPostCubit>().addPost(
                            value.text,
                            mediaUrls.value,
                            repostId,
                            isPublic.value,
                            taggedUsers: inputController.taggedUsers,
                            taggedCompanies: inputController.taggedCompanies,
                          );
                    }
                  : null,
              child: Text('Post'),
            );
          },
        ),
      )
    ],
  );
}

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({
    super.key,
    required this.isPublic,
  });
  final ValueNotifier<bool> isPublic;
  @override
  State<PrivacySettings> createState() => PrivacySettingsState();
}

class PrivacySettingsState extends State<PrivacySettings> {
  @override
  void initState() {
    super.initState();
  }

  void _updateSelectedValue(bool? value) {
    if (value != null) {
      setState(() {
        widget.isPublic.value = value;
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
                groupValue: widget.isPublic.value,
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
                groupValue: widget.isPublic.value,
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
