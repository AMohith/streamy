import 'package:flutter/material.dart';
import '../core.dart';

class ShowCard extends StatelessWidget {
  final Show show;

  const ShowCard({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to video player page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(show: show)),
        );
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show image
            Container(
              height: 155,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: NetworkImage(show.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),

            // Show title
            Text(
              show.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}