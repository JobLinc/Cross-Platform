class PostModel {
  PostModel({
    required this.postID,
    required this.username,
    required this.userID,
    required this.profilePictureURL,
    required this.text,
    required this.commentCount,
    required this.likesCount,
    required this.repostCount,
    this.attachmentURLs,
  });

  final String postID;
  final String userID;
  final String username;
  final String profilePictureURL;
  final String text;
  int commentCount;
  int likesCount;
  int repostCount;
  List<String>? attachmentURLs;
}
