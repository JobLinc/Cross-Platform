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

PostModel mockData = PostModel(postID: "1",
userID: "2",
username: "Tyrone",
profilePictureURL: "https://randomuser.me/api/portraits",
text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
commentCount: 4,
likesCount: 2,
repostCount: 1,
);
