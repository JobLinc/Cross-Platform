import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/profile_image.dart';

class UserHeader extends StatelessWidget {
  const UserHeader(
      {super.key,
      required this.imageURL,
      required this.username,
      required this.headline,
      required this.senderID,
      required this.isCompany,
      this.timestamp,
      this.action});

  ///Profile Picture URL
  final String imageURL;

  final String senderID;

  final String username;

  final bool isCompany;

  ///The grey text under the username
  final String headline;

  final DateTime? timestamp;

  ///Widget to be inserted at the end of the header
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isCompany
          ? Navigator.pushNamed(
              context,
              Routes.companyPageHome,
              arguments: senderID,
            )
          : Navigator.pushNamed(
              context,
              Routes.otherProfileScreen,
              arguments: senderID,
            ),
      child: Row(
        spacing: 8,
        key: Key('post_header_container'),
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
          action ?? SizedBox(),
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
    this.timestamp,
  });

  final String username;
  final String headline;
  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    String? timestampText;
    if (timestamp != null) {
      timestampText = '${timestamp?.difference(DateTime.now()).inDays}d';
      if (timestampText == '0d') {
        timestampText = '${timestamp?.difference(DateTime.now()).inHours}h';
      }
      if (timestampText == '0h') {
        timestampText = '${timestamp?.difference(DateTime.now()).inMinutes}m';
      }
    }
    return Column(
      key: Key('post_header_userInfoContainer'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key: Key('post_header_username'),
          username,
          style: TextStyle(
            fontWeight: FontWeightHelper.extraBold,
          ),
        ),
        Text(
          key: Key('post_header_headline'),
          headline,
          style: TextStyle(
            color: Colors.grey,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeightHelper.extraLight,
          ),
        ),
        timestamp != null
            ? Text(
                key: Key('post_header_headline'),
                timestampText!,
                style: TextStyle(
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeightHelper.extraLight,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
