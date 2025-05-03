import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    //_controller = VideoPlayerController.file(File(widget.url))
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) => setState(() {}))
      ..setLooping(false)
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video", style: TextStyle(fontSize: 18.sp))),

      body: Center(
      child: _controller.value.isInitialized
          ? LayoutBuilder(
              builder: (context, constraints) {
                final videoAspect = _controller.value.aspectRatio;
                final parentAspect = constraints.maxWidth / constraints.maxHeight;
                double width, height;
                if (videoAspect > parentAspect) {
                  width = constraints.maxWidth;
                  height = width / videoAspect;
                } else {
                  height = constraints.maxHeight;
                  width = height * videoAspect;
                }
                return SizedBox(
                  width: width,
                  height: height,
                  child: VideoPlayer(_controller),
                );
              },
            )
          : CircularProgressIndicator(),
    ),
    );
  }
}
