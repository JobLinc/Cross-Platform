class PostmediaModel {
  PostmediaModel({
    required this.mediaType,
    required this.url,
  });
  final MediaType mediaType;
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

MediaType parseMediaType(String type) {
  final string = type.toLowerCase();
  switch (string) {
    case 'image':
      return MediaType.image;
    case 'video':
      return MediaType.video;
    case 'document':
      return MediaType.document;
    case 'audio':
      return MediaType.audio;
    default:
      return MediaType.image;
  }
}

enum MediaType {
  image,
  video,
  document,
  audio,
}
