import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildChatAvatar(List<String>? chatPictures) {
  final pics = chatPictures!;
  // fallback image if list is empty
  final defaultUrl =
      'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg';
  
  if (pics.length <= 1) {
    final url = pics.isNotEmpty ? pics.first : defaultUrl;
    return CircleAvatar(
      radius: 25.r,
      backgroundImage: NetworkImage(url),
    );
  }else if (pics.length==2){
    return SizedBox(
    width: 50.r,
    height: 50.r,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // First avatar (back-left position)
        Positioned(
          left: 2.r,
          top: 2.r,
          child: CircleAvatar(
            radius: 15.r,
            backgroundImage: NetworkImage(pics[0]),
          ),
        ),
        // Second avatar (back-right position)
        Positioned(
          right: 2.r,
          bottom: 2.r,
          child: CircleAvatar(
            radius: 15.r,
            backgroundImage: NetworkImage(pics[1]),
          ),
        ),
      ],
    ),
  );
  }

  
  // more than 2: show first three in a triangular arrangement
  return SizedBox(
    width: 50.r,
    height: 50.r,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // First avatar (back-left position)
        Positioned(
          left: 0,
          top: 10.r,
          child: CircleAvatar(
            radius: 12.r,
            backgroundImage: NetworkImage(pics[0]),
          ),
        ),
        // Second avatar (back-right position)
        Positioned(
          right: 0,
          top: 10.r,
          child: CircleAvatar(
            radius: 12.r,
            backgroundImage: NetworkImage(pics[1]),
          ),
        ),
        // Third avatar (bottom-center position)
        Positioned(
          bottom: 0,
          child: CircleAvatar(
            radius: 12.r,
            backgroundImage: NetworkImage(
              pics.length > 2 ? pics[2] : defaultUrl,
            ),
          ),
        ),
      ],
    ),
  );
}