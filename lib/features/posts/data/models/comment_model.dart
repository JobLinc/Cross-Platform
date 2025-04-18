class CommentModel {
  CommentModel({
    required this.commentID,
    required this.postID,
    required this.senderID,
    required this.isReply,
    required this.username,
    required this.headline,
    required this.profilePictureURL,
    required this.text,
  });

  final String commentID;
  final String postID;
  final String senderID;
  final bool isReply;
  final String username;
  final String headline;
  final String profilePictureURL;
  final String text;
}

CommentModel mockCommentData = CommentModel(
  commentID: "5",
  postID: "1",
  senderID: "2",
  isReply: false,
  username: "Tyrone",
  headline: "senior smoker engineer with Phd in smoking rocks",
  profilePictureURL:
      "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
  text:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
);
