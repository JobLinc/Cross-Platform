import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';

class UserHeader extends StatelessWidget {
  //TODO add GestureDetector for the avatar + Info
  UserHeader(
      {super.key,
      required this.imageURL,
      required this.username,
      required this.headline,
      this.action});

  ///Profile Picture URL
  final String imageURL;

  final String username;

  ///The grey text under the username
  final String headline;

  ///Widget to be inserted at the end of the header
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'post_header_container',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfileImage(imageURL: imageURL),
          Expanded(
            flex: 9,
            child: UserInfo(
              username: username,
              headline: headline,
            ),
          ),
          Spacer(),
          action ?? SizedBox()
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.username,
    required this.headline,
  });

  final String username;
  final String headline;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'post_header_userInfoContainer',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            semanticsLabel: 'post_header_username',
            style: TextStyle(
              fontWeight: FontWeightHelper.extraBold,
            ),
          ),
          Text(
            headline,
            semanticsLabel: 'post_header_headline',
            style: TextStyle(
              color: Colors.grey,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeightHelper.extraLight,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.imageURL});
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    //TODO this needs revising
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Semantics(
        label: 'post_header_avatar',
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageURL),
        ),
      ),
    );
  }
}
