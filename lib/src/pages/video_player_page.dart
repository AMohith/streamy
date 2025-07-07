import 'package:flutter/material.dart';
import '../core.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required this.show});

  final Show show;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Player PageView
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: _onPageChanged,
            itemCount: widget.show.episodes.length,
            itemBuilder: (context, index) {
              return VideoPlayerItem(
                title: widget.show.title,
                url: widget.show.episodes[index].videoUrl,
                isCurrentPage: index == _currentPage,
              );
            },
          ),

          // Back button and Show Title
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 10,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white, size: 36),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.only(right: 4),
                ),
                Text(
                  '${Constants.episode}${_currentPage + 1} ${widget.show.title}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
