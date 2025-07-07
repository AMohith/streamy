import 'category.dart';
import 'show.dart';

class AppData {
  final List<Category> categories;
  final Show featuredShow;

  AppData({required this.categories, required this.featuredShow});

  factory AppData.fromJson(Map<String, dynamic> json) {
    final categoriesData = json['categories'] as Map<String, dynamic>;
    final categories = categoriesData.entries
        .map((entry) => Category.fromJson(entry.key, entry.value))
        .toList();

    return AppData(
      categories: categories,
      featuredShow: Show.fromJson(
        json['featured'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final categoriesMap = <String, dynamic>{};
    for (final category in categories) {
      categoriesMap[category.id] = category.toJson();
    }

    return {'categories': categoriesMap, 'featured': featuredShow.toJson()};
  }
}
