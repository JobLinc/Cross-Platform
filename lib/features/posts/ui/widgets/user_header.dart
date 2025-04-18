import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';

class UserHeader extends StatelessWidget {
  //TODO add GestureDetector for the avatar + Info
  UserHeader(
      {super.key,
      required this.imageURL,
      required this.username,
      required this.headline,
      required this.senderID,
      this.action});

  ///Profile Picture URL
  final String imageURL;

  final String senderID;

  final String username;

  ///The grey text under the username
  final String headline;

  ///Widget to be inserted at the end of the header
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.profileScreen),
      child: Row(
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
      ],
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
      child: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: imageURL.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  imageURL,
                  fit: BoxFit.fill,
                  width: 96.r,
                  height: 96.r,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      color: Colors.grey.shade400,
                    );
                  },
                ),
              )
            : Icon(
                Icons.person,
                color: Colors.grey.shade400,
              ),
      ),
    );
  }
}
