import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.imageURL, this.radius});
  final double? radius;
  final String? imageURL;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: imageURL != null && imageURL!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                imageURL!,
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
    );
  }
}
