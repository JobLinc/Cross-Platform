class CommentModel {
  CommentModel({
    required this.commentID,
    required this.postID,
    required this.senderID,
    required this.isReply,
    required this.isCompany,
    required this.username,
    required this.headline,
    required this.profilePictureURL,
    required this.text,
    this.timeStamp,
    required this.likeCount,
    required this.replyCount,
  });

  factory CommentModel.fromJson(json, String postId) {
    final bool companyComment = (json['userId'] == null);
    return CommentModel(
      commentID: json['commentId'],
      postID: postId,
      senderID: companyComment ? json['companyId'] : json['userId'],
      //TODO add this once reply is supported
      isReply: json['reply'] ?? false,
      isCompany: companyComment,
      username: companyComment
          ? json['companyName']
          : '${json['firstname']} ${json['lastname']}',
      headline: json['headline'] ?? '',
      profilePictureURL:
          companyComment ? json['companyLogo'] : json['commentId'],
      text: json['text'],
      likeCount: json['likes'],
      replyCount: json['comments'],
    );
  }

  final String commentID;
  final String postID;
  final String senderID;
  final bool isReply;
  final bool isCompany;
  final String username;
  final String headline;
  final String profilePictureURL;
  final String text;
  final DateTime? timeStamp;
  int likeCount;
  int replyCount;
}

CommentModel mockCommentData = CommentModel(
  commentID: "5",
  postID: "1",
  senderID: "2",
  isReply: false,
  isCompany: false,
  username: "Tyrone",
  headline: "senior smoker engineer with Phd in smoking rocks",
  timeStamp: DateTime.now(),
  likeCount: 5,
  replyCount: 3,
  profilePictureURL:
      "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
  text:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
);

CommentModel mockReplyData = CommentModel(
  commentID: "5",
  postID: "1",
  senderID: "2",
  isReply: true,
  isCompany: false,
  username: "Tyrone",
  headline: "senior smoker engineer with Phd in smoking rocks",
  timeStamp: DateTime.now(),
  likeCount: 5,
  replyCount: 3,
  profilePictureURL:
      "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
  text:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
);
