import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/user_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/data/services/tag_suggestion_service.dart';
import 'package:joblinc/features/posts/logic/cubit/edit_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/edit_post_state.dart';
import 'package:joblinc/features/posts/ui/widgets/tagged_text_controller.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel post;

  const EditPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TaggedTextEditingController _inputController;
  late List<PostmediaModel> _mediaItems;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  String _currentTagQuery = '';
  List<dynamic> _tagSuggestions = [];
  bool _isLoadingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _inputController = TaggedTextEditingController();
    _inputController.text = widget.post.text;
    _mediaItems = List.from(widget.post.attachmentURLs);

    // Initialize tagged users and companies from the post
    for (TaggedEntity user in widget.post.taggedUsers) {
      if (user is TaggedUser) {
        _inputController.taggedUsers.add(user);
      }
    }

    for (TaggedEntity company in widget.post.taggedCompanies) {
      if (company is TaggedCompany) {
        _inputController.taggedCompanies.add(company);
      }
    }

    _inputController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _inputController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
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
  }

  void _showTagSuggestions(String query) async {
    setState(() {
      _isLoadingSuggestions = true;
    });

    final tagSuggestionService = getIt<TagSuggestionService>();
    final tagIndex = _inputController.currentTagStartIndex!;

    List<TaggedUser> userSuggestions =
        await tagSuggestionService.getUserSuggestions(query);
    List<TaggedCompany> companySuggestions =
        await tagSuggestionService.getCompanySuggestions(query);

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
                    child: CompositedTransformTarget(
                      link: _layerLink,
                      child: TextField(
                        controller: _inputController,
                        autofocus: true,
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          hintText:
                              'Edit your post... Use @ to tag users or companies',
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(),
                        showCursor: true,
                        cursorColor: Colors.black,
                      ),
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
                          taggedUsers: _inputController.taggedUsers,
                          taggedCompanies: _inputController.taggedCompanies,
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
