import 'package:joblinc/features/posts/logic/reactions.dart';

class ReactionModel {
  final String reactId;
  final String reactorId;
  final String username;
  final String headline;
  final String profilePicture;
  final bool isCompany;
  final Reactions type;
  final DateTime time;

  ReactionModel({
    required this.reactId,
    required this.reactorId,
    required this.username,
    required this.headline,
    required this.isCompany,
    required this.profilePicture,
    required this.type,
    required this.time,
  });

  factory ReactionModel.fromJson( json) {
    print(json);
    final bool companyReaction = (json['userId'] == null);
    return ReactionModel(
      isCompany: companyReaction,
      reactId: json['reactId'],
      reactorId:
          companyReaction ? (json['companyId'] ?? '') : (json['userId'] ?? ''),
      username: companyReaction
          ? (json['companyName'] ?? '')
          : '${json['firstname'] ?? ''} ${json['lastname'] ?? ''}',
      headline: json['headline'] ?? '',
      profilePicture: companyReaction
          ? (json['companyLogo'] ?? '')
          : (json['profilePicture'] ?? ''),
      type: parseReactions(json['userReaction']) ?? Reactions.like,
      time: DateTime.parse(json['time']).toLocal(),
    );
  }
}
