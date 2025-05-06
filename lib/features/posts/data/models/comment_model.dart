import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';

class CommentModel {
  final String commentID;
  final String postID;
  final String senderID;
  final String text;
  final DateTime? timeStamp;
  final int likeCount;
  final bool isReply;
  final Reactions? userReaction;
  final String profilePictureURL;
  final String username;
  final String headline;
  final bool isCompany;
  final List<TaggedUser> taggedUsers;
  final List<TaggedCompany> taggedCompanies;

  CommentModel({
    required this.commentID,
    required this.postID,
    required this.senderID,
    required this.text,
    required this.timeStamp,
    required this.likeCount,
    required this.isReply,
    required this.userReaction,
    required this.profilePictureURL,
    required this.username,
    required this.headline,
    required this.isCompany,
    this.taggedUsers = const [],
    this.taggedCompanies = const [],
  });

  factory CommentModel.fromJson(Map<String, dynamic> json, String postId) {
    print(json);
    final bool companyComment = (json['userId'] == null);
    // Parse tagged users if they exist
    List<TaggedUser> taggedUsers = [];
    if (json['taggedUsers'] != null) {
      taggedUsers = (json['taggedUsers'] as List).map((user) {
        // Create a copy of the user object to work with
        Map<String, dynamic> tagData = {...user};

        // Try to find additional details for this user
        if (json.containsKey('taggedUserDetails') &&
            json['taggedUserDetails'] is Map &&
            json['taggedUserDetails'][user['id']] != null) {
          final userDetails = json['taggedUserDetails'][user['id']];

          // Add the firstname and lastname from details if available
          if (userDetails.containsKey('firstname') &&
              userDetails.containsKey('lastname')) {
            tagData['firstname'] = userDetails['firstname'];
            tagData['lastname'] = userDetails['lastname'];
            tagData['name'] =
                '${userDetails['firstname']} ${userDetails['lastname']}';
          } else if (userDetails.containsKey('username')) {
            tagData['username'] = userDetails['username'];
            tagData['name'] = userDetails['username'];
          }
        }

        return TaggedUser.fromJson(tagData);
      }).toList();
    }

    // Parse tagged companies if they exist
    List<TaggedCompany> taggedCompanies = [];
    if (json['taggedCompanies'] != null) {
      taggedCompanies = (json['taggedCompanies'] as List).map((company) {
        // Create a copy of the company object to work with
        Map<String, dynamic> tagData = {...company};

        // Try to find additional details for this company
        if (json.containsKey('taggedCompanyDetails') &&
            json['taggedCompanyDetails'] is Map &&
            json['taggedCompanyDetails'][company['id']] != null) {
          final companyDetails = json['taggedCompanyDetails'][company['id']];

          // Add the name from details if available
          if (companyDetails.containsKey('name')) {
            tagData['name'] = companyDetails['name'];
          }
        }

        return TaggedCompany.fromJson(tagData);
      }).toList();
    }

    String userReactionString = json['userReaction'] ?? '';
    Reactions? userReaction;
    if (userReactionString.isNotEmpty) {
      // Convert the reaction string to the enum value
      switch (userReactionString.toLowerCase()) {
        case 'like':
          userReaction = Reactions.like;
          break;
        case 'love':
          userReaction = Reactions.love;
          break;
        case 'celebrate':
          userReaction = Reactions.celebrate;
          break;
        case 'support':
          userReaction = Reactions.support;
          break;
        case 'insightful':
          userReaction = Reactions.insightful;
          break;
        case 'funny':
          userReaction = Reactions.funny;
          break;
      }
    }

    return CommentModel(
      commentID: json['commentId'] ?? '',
      postID: postId,
      senderID: companyComment ? json['companyId'] : json['userId'],

      isReply: json['reply'] ?? false,
      isCompany: companyComment,
      username: companyComment
          ? json['companyName']
          : '${json['firstname']} ${json['lastname']}',
      text: json['text'] ?? '',

      profilePictureURL:
          companyComment ? json['companyLogo'] : json['profilePicture'],
      headline: json['headline'] ?? '',
      userReaction: parseReactions(json['userReaction']),
      timeStamp: DateTime.parse(json['time']).toLocal(),

      taggedUsers: taggedUsers,
      taggedCompanies: taggedCompanies,
      likeCount: json['likes'],
      //replyCount: json['comments'],
    );
  }

  CommentModel copyWith({
    String? commentID,
    String? postID,
    String? senderID,
    String? text,
    DateTime? timeStamp,
    int? likeCount,
    bool? isReply,
    Reactions? userReaction,
    String? profilePictureURL,
    String? username,
    String? headline,
    bool? isCompany,
    List<TaggedUser>? taggedUsers,
    List<TaggedCompany>? taggedCompanies,
  }) {
    return CommentModel(
      commentID: commentID ?? this.commentID,
      postID: postID ?? this.postID,
      senderID: senderID ?? this.senderID,
      text: text ?? this.text,
      timeStamp: timeStamp ?? this.timeStamp,
      likeCount: likeCount ?? this.likeCount,
      isReply: isReply ?? this.isReply,
      userReaction: userReaction ?? this.userReaction,
      profilePictureURL: profilePictureURL ?? this.profilePictureURL,
      username: username ?? this.username,
      headline: headline ?? this.headline,
      isCompany: isCompany ?? this.isCompany,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      taggedCompanies: taggedCompanies ?? this.taggedCompanies,
    );
  }
}

CommentModel mockCommentData = CommentModel(
  commentID: '1',
  postID: '3',
  senderID: '4',
  text: 'test comment',
  timeStamp: DateTime.now(),
  likeCount: 2,
  isReply: false,
  userReaction: null,
  profilePictureURL: '',
  username: 'Tyrone biggums',
  headline: 'Marketting man with a plan',
  isCompany: false,
);
