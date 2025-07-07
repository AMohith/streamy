import 'show.dart';

class Category {
  final String id;
  final String title;
  final List<Show> shows;

  Category({required this.id, required this.title, required this.shows});

  factory Category.fromJson(String id, Map<String, dynamic> json) {
    return Category(
      id: id,
      title: json['title'] as String,
      shows: (json['shows'] as List<dynamic>)
          .map((showJson) => Show.fromJson(showJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'shows': shows.map((show) => show.toJson()).toList(),
    };
  }
}
