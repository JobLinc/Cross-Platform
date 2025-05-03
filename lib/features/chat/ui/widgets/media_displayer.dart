import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/services/chat_socket_service.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/document_viewer_screen.dart';
import 'package:joblinc/features/chat/ui/screens/video_player_screen.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

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
  // late final String _localPath;
  // bool _sent = false;

  @override
    void initState() {
    super.initState();
   }

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
          builder: (_) => DocumentViewerScreen(url: c.image,),
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
  return FutureBuilder<Uint8List?>(
    future: VideoThumbnail.thumbnailData(
      video: c.video,
      imageFormat: ImageFormat.PNG,
      maxWidth: 200, // specify the width of the thumbnail, let height auto-scale
      quality: 75,
    ),
    builder: (context, snapshot) {
      Widget thumb;
      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
        thumb = Image.memory(
          snapshot.data!,
          width: 200.w,
          height: 200.h,
          fit: BoxFit.cover,
        );
      } else {
        thumb = Container(
          width: 200.w,
          height: 200.h,
          color: Colors.black,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VideoPlayerScreen(url: c.video)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            thumb,
            Icon(Icons.play_circle_fill, size: 56.sp, color: Colors.white70),
          ],
        ),
      );
    },
  );
}

  if (c.document.isNotEmpty && c.document.startsWith('http')) {
  final name = c.document.split('/').last;
  final ext = name.split('.').last.toLowerCase();

  return InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentViewerScreen(url: c.document),
      ),
    ),
    child: Container(
      width: 220.w,
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          // first‑page preview at 25% opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: 
                  Container(color: Colors.grey[300]),  // fallback for .doc/.msword
            ),
          ),

          // icon + filename
          Row(
            children: [
              Icon(Icons.insert_drive_file,
                  size: 36.sp, color: Colors.grey),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 15.sp, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
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