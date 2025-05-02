import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoMediaWidget extends StatefulWidget {
  final String url;
  final String? thumbnailUrl;

  const VideoMediaWidget({super.key, required this.url, this.thumbnailUrl});

  @override
  State<VideoMediaWidget> createState() => _VideoMediaWidgetState();
}

class _VideoMediaWidgetState extends State<VideoMediaWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }).catchError((error) {
      print("Error initializing video: $error");
    });

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return _buildThumbnailOrLoading();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Video player
        VideoPlayer(_controller),

        // Play/pause button overlay
        GestureDetector(
          onTap: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
              _isPlaying = !_isPlaying;
            });
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: _isPlaying
                  ? const SizedBox.shrink()
                  : Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
            ),
          ),
        ),

        // Video progress indicator
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.red,
              bufferedColor: Colors.grey,
              backgroundColor: Colors.black45,
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailOrLoading() {
    if (widget.thumbnailUrl != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            widget.thumbnailUrl!,
            fit: BoxFit.cover,
          ),

          // Play button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),

          // Loading indicator
          Positioned(
            bottom: 16,
            right: 16,
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
