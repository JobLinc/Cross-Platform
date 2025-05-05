import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/user_service.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/login/ui/widgets/custom_rounded_textfield.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/data/repos/comment_repo.dart';
import 'package:joblinc/features/posts/data/services/tag_suggestion_service.dart';
import 'package:joblinc/features/posts/ui/widgets/comment.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
    required this.postId,
    required this.comments,
  });
  final List<CommentModel> comments;
  final String postId;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<CommentModel>> commentsNotifier =
        ValueNotifier(comments);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: comments.isNotEmpty
                      ? [
                          GestureDetector(
                            //TODO implement this sort
                            onTap: () {},
                            child: Row(
                              children: [
                                Text(
                                  'Most relevant',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeightHelper.semiBold),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: commentsNotifier,
                              builder: (context, commentsList, child) =>
                                  ListView.builder(
                                itemCount: commentsList.length,
                                itemBuilder: (context, index) => Comment(
                                  data: commentsList[index],
                                ),
                              ),
                            ),
                          ),
                        ]
                      : [Center(child: Text('No comments yet'))],
                ),
              ),
            ),
            Divider(
              height: 0,
            ),
            CommentBottomBar(
              postId: postId,
              commentNotifier: commentsNotifier,
            )
          ],
        ),
      ),
    );
  }
}

class CommentBottomBar extends StatefulWidget {
  const CommentBottomBar({
    Key? key,
    required this.postId,
    required this.commentNotifier,
  }) : super(key: key);

  final String postId;
  final ValueNotifier<List<CommentModel>> commentNotifier;

  @override
  State<CommentBottomBar> createState() => _CommentBottomBarState();
}

class _CommentBottomBarState extends State<CommentBottomBar> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<TaggedEntity> _taggedUsers = [];
  final List<TaggedEntity> _taggedCompanies = [];
  
  // For tag suggestions
  bool _showTagSuggestions = false;
  String _currentTagQuery = '';
  int _tagStartIndex = -1;
  List<TaggedEntity> _tagSuggestions = [];
  
  final TagSuggestionService _tagService = getIt<TagSuggestionService>();

  @override
  void initState() {
    super.initState();
    commentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    commentController.removeListener(_onTextChanged);
    commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = commentController.text;
    final selection = commentController.selection;
    
    // Check if we're in the process of typing a tag
    if (selection.baseOffset > 0 && selection.baseOffset <= text.length) {
      final textBeforeCursor = text.substring(0, selection.baseOffset);
      final lastAtSignIndex = textBeforeCursor.lastIndexOf('@');
      
      // If we have an @ and it's either at the start or preceded by a space
      if (lastAtSignIndex >= 0 && 
          (lastAtSignIndex == 0 || textBeforeCursor[lastAtSignIndex - 1] == ' ')) {
        final query = textBeforeCursor.substring(lastAtSignIndex + 1);
        
        // Only search if query changed
        if (query != _currentTagQuery) {
          _currentTagQuery = query;
          _tagStartIndex = lastAtSignIndex;
          _fetchTagSuggestions(query);
          setState(() {
            _showTagSuggestions = true;
          });
          return;
        }
      }
    }
    
    // If we're not typing a tag or deleted the @, hide suggestions
    if (_showTagSuggestions) {
      setState(() {
        _showTagSuggestions = false;
      });
    }
  }

  Future<void> _fetchTagSuggestions(String query) async {
    try {
      final userSuggestions = await _tagService.getUserSuggestions(query);
      final companySuggestions = await _tagService.getCompanySuggestions(query);
      
      setState(() {
        _tagSuggestions = [...userSuggestions, ...companySuggestions];
      });
    } catch (e) {
      print('Error fetching tag suggestions: $e');
    }
  }

  void _insertTag(TaggedEntity tag) {
    final text = commentController.text;
    final tagText = tag is TaggedUser ? tag.name : (tag as TaggedCompany).name;
    
    // Remove the @ and query and replace with the tag
    final newText = text.substring(0, _tagStartIndex) + 
                    '@$tagText ' + 
                    text.substring(_tagStartIndex + _currentTagQuery.length + 1);
    
    // Update the tag's index to point to where it starts in the text
    final taggedEntity = tag is TaggedUser 
        ? TaggedUser(id: tag.id, index: _tagStartIndex, name: tagText)
        : TaggedCompany(id: tag.id, index: _tagStartIndex, name: tagText);
    
    // Add to appropriate list
    if (tag is TaggedUser) {
      _taggedUsers.add(taggedEntity);
    } else {
      _taggedCompanies.add(taggedEntity);
    }
    
    // Update text and cursor position
    commentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: _tagStartIndex + tagText.length + 2),
    );
    
    setState(() {
      _showTagSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tag suggestions if active
        if (_showTagSuggestions && _tagSuggestions.isNotEmpty)
          Container(
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _tagSuggestions.length,
              itemBuilder: (context, index) {
                final tag = _tagSuggestions[index];
                final name = tag is TaggedUser 
                    ? tag.name 
                    : (tag as TaggedCompany).name;
                
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(tag is TaggedUser ? Icons.person : Icons.business),
                  ),
                  title: Text(name),
                  onTap: () => _insertTag(tag),
                );
              },
            ),
          ),
        
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            spacing: 10,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomRoundedTextFormField(
                    controller: commentController,
                    //focusNode: _focusNode,
                    filled: false,
                    borderRadius: BorderRadius.circular(40),
                    hintText: "Add a comment... Use @ to tag",
                    hintStyle: TextStyle(color: Colors.grey),
                    autofocus: true,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (commentController.text.isNotEmpty) {
                    try {
                      final repo = getIt.get<CommentRepo>();
                      final commentId = await repo.addComment(
                        widget.postId, 
                        commentController.text,
                        taggedUsers: _taggedUsers,
                        taggedCompanies: _taggedCompanies,
                      );
                          
                      widget.commentNotifier.value = await repo.getComments(widget.postId);
                      
                      // Clear for next comment
                      commentController.text = '';
                      _taggedUsers.clear();
                      _taggedCompanies.clear();
                    } on Exception catch (e) {
                      if (context.mounted) {
                        CustomSnackBar.show(
                          context: context,
                          message: e.toString(),
                          type: SnackBarType.error,
                        );
                      }
                    }
                  }
                },
                icon: Icon(Icons.send)
              )
            ],
          ),
        ),
      ],
    );
  }
}

Future<dynamic> showCommentSectionBottomSheet(
    BuildContext context, String postId, List<CommentModel> comments) {
  return showModalBottomSheet(
    showDragHandle: true,
    scrollControlDisabledMaxHeightRatio: 0.9,
    context: context,
    builder: (context) {
      return CommentSection(
        postId: postId,
        comments: comments,
      );
    },
  );
}
