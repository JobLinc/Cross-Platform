import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/ui/widgets/audio_media.dart';
import 'package:joblinc/features/posts/ui/widgets/document_media.dart';
import 'package:joblinc/features/posts/ui/widgets/image_media.dart';
import 'package:joblinc/features/posts/ui/widgets/video_media.dart';

class MultimediaHandler extends StatelessWidget {
  final PostmediaModel mediaItem;
  final BorderRadius? borderRadius;

  const MultimediaHandler({
    super.key,
    required this.mediaItem,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: _buildMediaContent(),
    );
  }

  // Method to build the appropriate media content based on type
  Widget _buildMediaContent() {
    switch (mediaItem.mediaType) {
      case MediaType.image:
        return ImageMediaWidget(url: mediaItem.url);
      case MediaType.video:
        return VideoMediaWidget(url: mediaItem.url);
      case MediaType.audio:
        return AudioMediaWidget(url: mediaItem.url);
      case MediaType.document:
        return DocumentMediaWidget(url: mediaItem.url);
    }
  }
}

Widget buildMultipleMediaGrid(List<PostmediaModel> mediaItems) {
  if (mediaItems.length == 1) {
    return MultimediaHandler(mediaItem: mediaItems[0]);
  } else if (mediaItems.length == 2) {
    return Row(
      children: [
        Expanded(
          child: MultimediaHandler(
            mediaItem: mediaItems[0],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
        ),
        Expanded(
          child: MultimediaHandler(
            mediaItem: mediaItems[1],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(0),
            ),
          ),
        ),
      ],
    );
  } else if (mediaItems.length == 3) {
    return Column(
      children: [
        MultimediaHandler(
          mediaItem: mediaItems[0],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: MultimediaHandler(
                mediaItem: mediaItems[1],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
            ),
            Expanded(
              child: MultimediaHandler(
                mediaItem: mediaItems[2],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  } else if (mediaItems.length >= 4) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MultimediaHandler(
                mediaItem: mediaItems[0],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
            ),
            Expanded(
              child: MultimediaHandler(
                mediaItem: mediaItems[1],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(0),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: MultimediaHandler(
                mediaItem: mediaItems[2],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  MultimediaHandler(
                    mediaItem: mediaItems[3],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    ),
                  ),
                  if (mediaItems.length > 4)
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "+${mediaItems.length - 4}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  return const SizedBox.shrink();
}
