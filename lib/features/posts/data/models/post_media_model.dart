class PostmediaModel {
  PostmediaModel({
    required this.mediaType,
    required this.url,
  });
  final PostMediaType mediaType;
  final String url;

  factory PostmediaModel.fromJson(json) {
    print(json);
    return PostmediaModel(
      mediaType: parseMediaType(json['type']),
      url: json['url'],
    );
  }
}

List<PostmediaModel> parsePostMedia(json) {
  List<PostmediaModel> postMedia = [];
  for (Map<String, dynamic> media in json) {
    postMedia.add(PostmediaModel.fromJson(media));
  }
  return postMedia;
}

PostMediaType parseMediaType(String type) {
  final string = type.toLowerCase();
  switch (string) {
    case 'image':
      return PostMediaType.image;
    case 'video':
      return PostMediaType.video;
    case 'document':
      return PostMediaType.document;
    case 'audio':
      return PostMediaType.audio;
    default:
      return PostMediaType.image;
  }
}

enum PostMediaType { image, video, document, audio }
