import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/posts/ui/widgets/user_header.dart';

class Comment extends StatelessWidget {
  const Comment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserHeader(
          imageURL:
              "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
          username: 'Tyrone',
          headline: "senior smoker engineer with Phd in smoking rocks",
          action: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 50, top: 3, bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text('Sample text'),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: ColorsManager.charcoalBlack,
                      shape: LinearBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      minimumSize: Size(20, 45),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('Like'),
                  ),
                  Text(' | '),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: ColorsManager.charcoalBlack,
                      shape: LinearBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      minimumSize: Size(20, 45),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('Reply'),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
