class Episode {
  final String id;
  final String videoUrl;
  final int episode;

  Episode({
    required this.id,
    required this.videoUrl,
    required this.episode,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String,
      episode: json['episode'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'episode': episode,
    };
  }
}
