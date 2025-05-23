import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/di/dependency_injection.dart';


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
      onTap: () async {
        final auth = getIt<AuthService>();
        final userId = await auth.getUserId();
        if (context.mounted) {
          if (userId == senderID) {
            Navigator.pushNamed(context, Routes.profileScreen);
          } else if (isCompany) {
            Navigator.pushNamed(
              context,
              Routes.companyPageHome,
              arguments: senderID,
            );
          } else {
            Navigator.pushNamed(
              context,
              Routes.otherProfileScreen,
              arguments: senderID,
            );
          }
        }
      },
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
              timestamp: timestamp,
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
      timestampText = '${DateTime.now().difference(timestamp!).inDays}d';
      if (timestampText == '0d') {
        timestampText = '${DateTime.now().difference(timestamp!).inHours}h';
      }
      if (timestampText == '0h') {
        timestampText = '${DateTime.now().difference(timestamp!).inMinutes}m';
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
        headline.isNotEmpty
            ? Text(
                key: Key('post_header_headline'),
                headline,
                style: TextStyle(
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeightHelper.extraLight,
                ),
              )
            : SizedBox(),
        timestamp != null
            ? Text(
                key: Key('post_header_timestamp'),
                timestampText!,
                style: TextStyle(
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeightHelper.extraLight,
                  fontSize: 12,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
