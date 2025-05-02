import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
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


final _dio = Dio();

/// Download with Dio, render page 1 with pdf_render, return raw RGBA pixels.
// Future<Uint8List> renderPdfFirstPage(String url) async {
//   // 1) fetch into memory
//   final resp = await _dio.get<List<int>>(
//     url,
//     options: Options(responseType: ResponseType.bytes),
//   );
//   if (resp.statusCode != 200 || resp.data == null) {
//     throw Exception('PDF download failed: ${resp.statusCode}');
//   }
//   final data = Uint8List.fromList(resp.data!);

//   // 2) open PDF
//   final doc = await PdfDocument.openData(data);

//   // 3) grab page 1
//   final page = await doc.getPage(1);

//   // 4) render full‑page image
//   final pageImage = await page.render(
//     width: page.width.toInt(),
//     height: page.height.toInt(),
//   );

//   // 5) extract RGBA bytes
//   final pixels = pageImage.pixels;

//   // 6) clean up
//   await doc.dispose();

//   return pixels;
// }

/// Downloads `url` into memory via Dio, renders page 1, returns RGBA bytes.
// Future<Uint8List> renderPdfFirstPage(String url) async {
//   // Dio’s get with responseType=bytes gives you the full file in memory.
//   final resp = await _dio.get<List<int>>(
//     url,
//     options: Options(responseType: ResponseType.bytes),
//   );
//   if (resp.statusCode != 200 || resp.data == null) {
//     throw Exception('PDF download failed: ${resp.statusCode}');
//   }

//   final data = Uint8List.fromList(resp.data!);
//   final doc = await PdfDocument.openData(data);
//   final page = await doc.getPage(1);
//   final pageImage = await page.render(); 
//   await page.close();
//   await doc.close();
//   return pageImage.bytes;
// }



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
  late final String _localPath;
  bool _sent = false;

  @override
    void initState() {
    super.initState();
   // final c = widget.message.content;
  //   // pick whichever non-URL path:
  //   _localPath = c.image.isNotEmpty && !c.image.startsWith('http') ? c.image
  //              : c.video.isNotEmpty && !c.video.startsWith('http') ? c.video
  //              : c.document.isNotEmpty && !c.document.startsWith('http') ? c.document
  //              : "";
  //   if (_localPath.isNotEmpty) {
  //     context.read<ChatCubit>().uploadMedia(File(_localPath));
  //   }
   }


    @override
//   Widget build(BuildContext context) {
//     return BlocListener<ChatCubit, ChatState>(
//       listener: (context, state) {
//         if (!_sent && state is MediaUploaded) {
//           _sent = true;
//           final c = widget.message.content;
//           // replace local path with URL
//           if (c.image == _localPath) c.image = state.url;
//           if (c.video == _localPath) c.video = state.url;
//           if (c.document == _localPath) c.document = state.url;
//           // now send exactly once
//           widget.socketService.sendFileMessage(
//             widget.chatId,
//             state.url,
//             c.image.isNotEmpty ? 'image' :
//             c.video.isNotEmpty ? 'video' : 'document',
//           );
//         }
//       },
//       child: buildMediaContent(context, widget.message.content),
//     );
//   }
// }

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
 



// ...existing code...

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


// if (c.document.isNotEmpty && c.document.startsWith('http')) {
//   final name = c.document.split('/').last;
//   final ext = name.split('.').last.toLowerCase();

//   return InkWell(
//     onTap: () => Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => DocumentViewerScreen(url: c.document)),
//     ),
//     child: Container(
//       width: 220.w,
//       height: 80.h,
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Stack(
//         children: [
//           // ── first-page preview ─────────────────────────────────────
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.25,
//               child: ext == 'pdf'
//                   ? FutureBuilder<Uint8List>(
//                       future: renderPdfFirstPage(c.document),
//                       builder: (ctx, snap) {
//                         if (snap.connectionState == ConnectionState.done &&
//                             snap.hasData) {
//                           return Image.memory(
//                             snap.data!,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: double.infinity,
//                           );
//                         } else {
//                           return Container(color: Colors.grey[300]);
//                         }
//                       },
//                     )
//                   : Container(color: Colors.grey[300]),  // no preview for Word
//             ),
//           ),

//           // ── foreground icon + filename ─────────────────────────────
//           Row(
//             children: [
//               Icon(Icons.insert_drive_file,
//                   size: 36.sp, color: Colors.grey),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Text(
//                   name,
//                   style: TextStyle(
//                       fontSize: 15.sp, fontWeight: FontWeight.w500),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

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
              // ext == 'pdf'
              //     ? FutureBuilder<Uint8List>(
              //         future: renderPdfFirstPage(c.document),
              //         builder: (ctx, snap) {
              //           if (snap.connectionState == ConnectionState.done &&
              //               snap.hasData) {
              //             return Image.memory(
              //               snap.data!,
              //               fit: BoxFit.cover,
              //               width: double.infinity,
              //               height: double.infinity,
              //             );
              //           } else {
              //             return Container(color: Colors.grey[300]);
              //           }
              //         },
              //       )
                  // : 
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


// if (c.document.isNotEmpty && c.document.startsWith('http')) {
//   final name = c.document.split('/').last;
//   return InkWell(
//     onTap: () => Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => DocumentViewerScreen(url: c.document,),
//       ),
//     ),
//     child: Container(
//       width: 220.w,
//       height: 80.h,
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Stack(
//         children: [
//           // Document preview background (first page as thumbnail)
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.25,
//               child: FutureBuilder<Uint8List?>(
//                 future: VideoThumbnail.thumbnailData( // Use video_thumbnail for PDF preview if you have a PDF thumbnail generator, else use a placeholder
//                   video: '', // <-- Replace with PDF thumbnail generator if available
//                   imageFormat: ImageFormat.PNG,
//                   maxWidth: 220,
//                   quality: 50,
//                 ),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//                     return Image.memory(
//                       snapshot.data!,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                       height: double.infinity,
//                     );
//                   } else {
//                     // Placeholder for document preview
//                     return Container(
//                       color: Colors.grey[300],
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//           // Foreground row with icon and name
//           Row(
//             children: [
//               Icon(Icons.insert_drive_file, size: 36.sp, color: Colors.grey),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Text(
//                   name,
//                   style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
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
    //   }// if (c.document.isNotEmpty && c.document.startsWith('http')) {
  //   final name = c.document.split('/').last;
  //   return InkWell(
  //     onTap: () => Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => DocumentViewerScreen(url: c.document, type: 'pdf'),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(Icons.insert_drive_file, size: 24.sp, color: Colors.grey),
  //         SizedBox(width: 8.w),
  //         Expanded(child: Text(name, style: TextStyle(fontSize: 14.sp))),
  //       ],
  //     ),
  //   );
  // }

  // if (c.document.isNotEmpty && c.document.startsWith('http')) {
  // final name = c.document.split('/').last;
  // return InkWell(
  //   onTap: () => Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => DocumentViewerScreen(url: c.document, type: 'pdf'),
  //     ),
  //   ),
  //   child: Container(
  //     width: 220.w,
  //     height: 80.h,
  //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[100],
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.grey[300]!),
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(Icons.insert_drive_file, size: 36.sp, color: Colors.grey),
  //         SizedBox(width: 12.w),
  //         Expanded(
  //           child: Text(
  //             name,
  //             style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
// } // if (c.video.isNotEmpty && c.video.startsWith('http')) {
  //   return GestureDetector(
  //     onTap: () => Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (_) => VideoPlayerScreen(url: c.video)),
  //     ),
  //     child: Container(
  //       width: 200.w,
  //       height: 200.h,
  //       color: Colors.black,
  //       child: Icon(Icons.play_arrow, size: 50.sp, color: Colors.white),
  //     ),
  //   );
  // }