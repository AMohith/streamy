import 'package:flutter/material.dart';
import '../core.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({super.key, required this.featuredShow});

  final Show featuredShow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to video player page when the banner is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(show: featuredShow),
          ),
        );
      },
      child: Container(
        height: 420,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 15,
              offset: Offset(2, 6), 
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white70.withValues(alpha: 0.6),
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(featuredShow.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
            ),

            // featured show title
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    featuredShow.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
