class PostModel {
  PostModel({
    required this.postID,
    required this.senderID,
    required this.isCompany,
    required this.username,
    required this.headline,
    required this.profilePictureURL,
    required this.text,
    required this.attachmentURLs,
    required this.commentCount,
    required this.likeCount,
    required this.repostCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final bool companyPost;
    if (json['userId']) {
      companyPost = true;
    } else {
      companyPost = false;
    }

    return PostModel(
      postID: json['postId'],
      senderID: companyPost ? (json['compamyId']) : (json['userId']),
      isCompany: companyPost,
      username: companyPost
          ? json['companyName']
          : '${json['firstname']} ${json['lastname']}',
      headline: json['headline'],
      profilePictureURL:
          companyPost ? json['companyLogo'] : json['profilePicture'],
      text: json['text'],
      attachmentURLs: json['attachments'],
      commentCount: json['comments'],
      likeCount: json['likes'],
      repostCount: json['reposts'],
    );
  }

  final String postID;
  final String senderID;
  final bool isCompany;
  final String username;
  final String headline;
  final String profilePictureURL;
  final String text;
  List<String> attachmentURLs;
  int commentCount;
  int likeCount;
  int repostCount;
}

PostModel mockData = PostModel(
  postID: "1",
  senderID: "2",
  isCompany: false,
  username: "Tyrone",
  headline: "senior smoker engineer with Phd in smoking rocks",
  profilePictureURL:
      "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
  text:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  attachmentURLs: ['https://d.newsweek.com/en/full/940601/05-23-galaxy.jpg'],
  commentCount: 1,
  likeCount: 2,
  repostCount: 1,
);
