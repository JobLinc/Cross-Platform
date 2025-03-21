import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/features/posts/ui/widgets/comment.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        spacing: 10,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'Most relevant',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeightHelper.semiBold),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 20, itemBuilder: (context, index) => Comment()),
          )
        ],
      ),
    );
  }
}
