import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/notifications/ui/widgets/notification_item_builder.dart';

Widget buildNotificationsList({
  required BuildContext context,
}) {
  return ListView(
    padding: EdgeInsets.only(top: 8.h),
    children: [
      buildNotificationItem(
        context: context,
        avatar: 'assets/images/person1.png',
        name: 'Ahmed Maged',
        action: 'just reposted.',
        time: '3h',
        isBlueBackground: false,
      ),
      buildNotificationItem(
        context: context,
        avatar: 'assets/images/person2.png',
        name: 'Gasser Elkomy',
        action: 'commented on\nShimaa Esaeed\'s post: جميل, لسه منزل',
        time: '6h',
        isBlueBackground: false,
      ),
      buildNotificationItem(
        context: context,
        avatar: 'assets/images/person3.png',
        name: 'People are viewing',
        action: 'Ahmad Fathy\'s post',
        subtitle: '164 reactions • 3 comments',
        time: '7h',
        isBlueBackground: true,
      ),
      buildNotificationItem(
        context: context,
        avatar: 'assets/images/linkedin_icon.png',
        name: 'You appeared in',
        action: '14 searches this week.',
        time: '7h',
        isBlueBackground: true,
        isSpecialIcon: true,
      ),
      buildNotificationItem(
        context: context,
        avatar: 'assets/images/person4.png',
        name: 'Suggested for you:',
        action:
            'More early-stage startups should be hiring Brazilian developers. 🇧🇷 I\'ve worked with dev...',
        subtitle: '397 reactions • 120 comments',
        time: '8h',
        isBlueBackground: true,
      ),
      buildNotificationItem(
        context: context,
        avatar: 'assets/images/person5.png',
        name: 'Mahmoud Mansy',
        action: 'commented on\nHouari ZEGAI\'s post: نفع الله بك ورزقك الإخلاص',
        time: '14h',
        hasOnlineIndicator: true,
        isBlueBackground: false,
      ),
      buildNotificationItem(
        context: context,
        avatar: 'assets/images/company_logo.png',
        name: 'ETIC, Applied AI - Graduate Program',
        action: 'at PwC and 9 other recommendations for you.',
        time: '15h',
        isBlueBackground: false,
        isSpecialIcon: true,
      ),
    ],
  );
}
