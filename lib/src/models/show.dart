import 'episode.dart';

class Show {
  final String id;
  final String title;
  final String imageUrl;
  final List<Episode> episodes;

  Show({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.episodes,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      episodes: (json['episodes'] as List<dynamic>)
          .map(
            (episodeJson) =>
                Episode.fromJson(episodeJson as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'episodes': episodes.map((episode) => episode.toJson()).toList(),
    };
  }
}
