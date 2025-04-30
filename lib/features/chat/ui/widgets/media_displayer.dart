import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/services/chat_socket_service.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/document_viewer_screen.dart';
import 'package:joblinc/features/chat/ui/screens/video_player_screen.dart';

class MediaDisplayer extends StatefulWidget {
  final String chatId;
  final Message message;
  final ChatSocketService socketService;

  const MediaDisplayer({
    required this.message,
    required this.socketService,
    required this.chatId,
    Key? key,
  }) : super(key: key);

  @override
  State<MediaDisplayer> createState() => _MediaDisplayerState();
}

class _MediaDisplayerState extends State<MediaDisplayer> {
  bool _hasStartedUpload = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.message.content;

    // Only trigger upload if not already uploading and not a URL
    if (!_hasStartedUpload &&
        ((c.image.isNotEmpty && !c.image.startsWith('http')) ||
            (c.video.isNotEmpty && !c.video.startsWith('http')) ||
            (c.document.isNotEmpty && !c.document.startsWith('http')))) {
      _hasStartedUpload = true;

      if (c.image.isNotEmpty) {
        File file = File(c.image);
        context.read<ChatCubit>().uploadMedia(file);
      } else if (c.video.isNotEmpty) {
        File file = File(c.video);
        context.read<ChatCubit>().uploadMedia(file);
      } else if (c.document.isNotEmpty) {
        File file = File(c.document);
        context.read<ChatCubit>().uploadMedia(file);
      }
    }

    return SizedBox(
      height: 200.h,
      width: 200.w,
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is MediaUploading) {
            return Container(
              width: 200,
              height: 200,
              color: Colors.grey[200],
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is MediaUploaded) {
            // Update message content and send via socket
            if (c.image.isNotEmpty && !c.image.startsWith('http')) {
               WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                c.image = state.url;
              });
              widget.socketService
                  .sendFileMessage(widget.chatId, state.url, "image");
            });}
            if (c.video.isNotEmpty && !c.video.startsWith('http')) {
               WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                c.video = state.url;
              });
              widget.socketService
                  .sendFileMessage(widget.chatId, state.url, "video");
            });}
            if (c.document.isNotEmpty && !c.document.startsWith('http')) {
               WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                c.document = state.url;
              });
              widget.socketService
                  .sendFileMessage(widget.chatId, state.url, "document");
            });}
            return buildMediaContent(context, c);
          } else if (state is MediaUploadingError) {
            return Container(
              width: 200,
              height: 60,
              color: Colors.red[100],
              child: Center(
                child: Text('Error uploading media: ${state.error}',
                    style: TextStyle(color: Colors.red)),
              ),
            );
          }
          return buildMediaContent(context, c);
        },
      ),
    );
  }
}

Widget buildMediaContent(BuildContext context, MessageContent c) {
  if (c.image.isNotEmpty && c.image.startsWith('http')) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DocumentViewerScreen(url: c.image, type: 'image'),
        ),
      ),
      child: Image.network(
        c.image,
        width: 200.w,
        height: 200.h,
        fit: BoxFit.cover,
      ),
    );
  }
  if (c.video.isNotEmpty && c.video.startsWith('http')) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoPlayerScreen(url: c.video)),
      ),
      child: Container(
        width: 200.w,
        height: 200.h,
        color: Colors.black,
        child: Icon(Icons.play_arrow, size: 50.sp, color: Colors.white),
      ),
    );
  }
  if (c.document.isNotEmpty && c.document.startsWith('http')) {
    final name = c.document.split('/').last;
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DocumentViewerScreen(url: c.document, type: 'pdf'),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file, size: 24.sp, color: Colors.grey),
          SizedBox(width: 8.w),
          Expanded(child: Text(name, style: TextStyle(fontSize: 14.sp))),
        ],
      ),
    );
  }
  // Show placeholder for local file before upload
  if (c.image.isNotEmpty) {
    return Container(
      width: 200.w,
      height: 200.h,
      color: Colors.grey[200],
      child: Center(child: CircularProgressIndicator()),
    );
  }
  if (c.video.isNotEmpty) {
    return Container(
      width: 200.w,
      height: 200.h,
      color: Colors.black,
      child: Center(child: CircularProgressIndicator()),
    );
  }
  if (c.document.isNotEmpty) {
    final name = c.document.split('/').last;
    return Row(
      children: [
        Icon(Icons.insert_drive_file, size: 24.sp, color: Colors.grey),
        SizedBox(width: 8.w),
        Expanded(child: Text(name, style: TextStyle(fontSize: 14.sp))),
        CircularProgressIndicator(),
      ],
    );
  }
  return ConstrainedBox(constraints: 
    BoxConstraints(maxHeight: 200.h, maxWidth: 200.w),
    child: Center(child: Text('No media available')),
  );
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:joblinc/features/chat/data/models/message_model.dart';
// import 'package:joblinc/features/chat/data/services/chat_socket_service.dart';
// import 'package:joblinc/features/chat/logic/cubit/chat_cubit.dart';
// import 'package:joblinc/features/chat/ui/screens/document_viewer_screen.dart';
// import 'package:joblinc/features/chat/ui/screens/video_player_screen.dart';

// class MediaDisplayer extends StatelessWidget {
//   final String chatId;
//   Message message;
//   final ChatSocketService socketService;

//   MediaDisplayer(
//       {required this.message,
//       required this.socketService,
//       required this.chatId, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //final c=message.content;
//     return Stack(
//       children: <Widget>[
//         buildMediaContent(context, message.content),
//         BlocBuilder<ChatCubit, ChatState>(
//           builder: (context, state) {
//             if (state is MediaUploading) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (state is MediaUploaded) {
//               if (message.content.image.isNotEmpty) {
//                 message.content.image = state.url;
//                 socketService.sendFileMessage(chatId, state.url, "image");
//               }
//               if (message.content.video.isNotEmpty) {
//                 message.content.video = state.url;
//                 socketService.sendFileMessage(chatId, state.url, "video");
//               }
//               if (message.content.document.isNotEmpty) {
//                 message.content.document = state.url;
//                 socketService.sendFileMessage(chatId, state.url, "document");
//               }
//               // socketService.sendMessage(
//               //   chatId: chatId,
//               //   message: message,
//               // );
//               return Center(
//                 child: Text(''),
//               );
//             } else if (state is MediaUploadingError) {
//               return Center(
//                 child: Text('Error uploading media: ${state.error}'),
//               );
//             }
//             return SizedBox();
//           },
//         ),
//       ],
//     );
//   }
// }

// Widget buildMediaContent(BuildContext context, dynamic content) {
//   final c = content;
//   if (c.image.isNotEmpty) {
//     if (!c.image.startsWith('http')) {
//       context.read<ChatCubit>().uploadMedia(
//             c.image,
//           );
//     }
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => DocumentViewerScreen(url: c.image, type: 'image'),
//         ),
//       ),
//       child: Image.network(
//         c.image,
//         width: 200.w,
//         height: 200.h,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
//   if (c.video.isNotEmpty) {
//     if (!c.video.startsWith('http')) {
//       context.read<ChatCubit>().uploadMedia(
//             c.video,
//           );
//     }
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => VideoPlayerScreen(url: c.video)),
//       ),
//       child: Container(
//         width: 200.w,
//         height: 200.h,
//         color: Colors.black,
//         child: Icon(Icons.play_arrow, size: 50.sp, color: Colors.white),
//       ),
//     );
//   }
//   if (c.document.isNotEmpty) {
//     if (!c.document.startsWith('http')) {
//       context.read<ChatCubit>().uploadMedia(
//             c.document,
//           );
//     }
//     final name = c.document.split('/').last;
//     return InkWell(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => DocumentViewerScreen(url: c.document, type: 'pdf'),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.insert_drive_file, size: 24.sp, color: Colors.grey),
//           SizedBox(width: 8.w),
//           Expanded(child: Text(name, style: TextStyle(fontSize: 14.sp))),
//         ],
//       ),
//     );
//   }
//   return SizedBox(); // Return an empty widget if no media is found
// }
//if (c.image.isNotEmpty) {
//  if (!c.image.sartsWith('http')) { context.read<ChatCubit>().uploadM}
//   return GestureDetector(
    //     onTap: () => Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => DocumentViewerScreen(url: c.image, type: 'image'),
    //       ),
    //     ),
    //     child: Image.network(
    //       c.image,
    //       width: 200.w,
    //       height: 200.h,
    //       fit: BoxFit.cover,
    //     ),
    //   );
    // }
    //   if (c.video.isNotEmpty) {
    //     return GestureDetector(
    //       onTap: () => Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (_) => VideoPlayerScreen(url: c.video)),
    //       ),
    //       child: Container(
    //         width: 200.w,
    //         height: 200.h,
    //         color: Colors.black,
    //         child: Icon(Icons.play_arrow, size: 50.sp, color: Colors.white),
    //       ),
    //     );
    //   }
    //   if (c.document.isNotEmpty) {
    //     final name = c.document.split('/').last;
    //     // return InkWell(
    //     //   onTap: () => OpenFile.open(c.document),
    //     //   child: Row(
    //     //     children: [
    //     //       Icon(Icons.insert_drive_file, size: 24.sp, color: Colors.grey),
    //     //       SizedBox(width: 8.w),
    //     //       Expanded(child: Text(name, style: TextStyle(fontSize: 14.sp))),
    //     //     ],
    //     //   ),
    //     // );
    //   return InkWell(
    //     onTap: () => Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => DocumentViewerScreen(url: c.document, type: 'pdf'),
    //       ),
    //     ),
    //     child: Row(
    //       children: [
    //         Icon(Icons.insert_drive_file, size: 24.sp,rs.grey),
    //         SizedBox(width: 8.w),
    //         Expanded(child: Text(name, style: TextStyle(fontSize: 14.sp))),
    //       ],
    //     ),
    //   );
    //   }