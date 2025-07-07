import 'dart:convert';
import 'package:flutter/services.dart';
import '../core.dart';

class ShowsRepository {
  AppData? _cachedData;

  // Load and parse JSON data
  Future<AppData> loadShowsData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/shows.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedData = AppData.fromJson(jsonData);
      return _cachedData!;
    } catch (e) {
      throw Exception('Failed to load shows data: $e');
    }
  }

  // Clear cache
  void clearCache() {
    _cachedData = null;
  }
}
