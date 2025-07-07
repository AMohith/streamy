import 'package:flutter/material.dart';
import '../core.dart';

class ShowsDisplay extends StatelessWidget {
  final String catTitle;
  final List<Show> shows;

  const ShowsDisplay({super.key, required this.catTitle, required this.shows});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              catTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),

          // Horizontal list of shows
          SizedBox(
            height: 185,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: shows.map((show) => ShowCard(show: show)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
