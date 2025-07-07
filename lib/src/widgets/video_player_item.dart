import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String title;
  final String url;
  final bool isCurrentPage;

  const VideoPlayerItem({
    super.key,
    required this.title,
    required this.url,
    required this.isCurrentPage,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  BetterPlayerController? _betterPlayerController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle auto-play/pause when page changes
    if (widget.isCurrentPage != oldWidget.isCurrentPage) {
      if (widget.isCurrentPage) {
        _betterPlayerController?.play();
      } else {
        _betterPlayerController?.pause();
      }
    }
  }
  
  void _initializePlayer() {
    final BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.url,
          bufferingConfiguration: BetterPlayerBufferingConfiguration(
            minBufferMs: 3000,
            maxBufferMs: 12000,
            bufferForPlaybackMs: 1000,
            bufferForPlaybackAfterRebufferMs: 2000,
          ),
        );

    final BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
          autoPlay: true,
          looping: true,
          fit: BoxFit.cover,
          aspectRatio: 9 / 16,
          fullScreenByDefault: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableMute: true,
            enableFullscreen: false,
            enableOverflowMenu: false,
            enablePlayPause: true,
            controlBarColor: Colors.transparent,
            controlBarHeight: 40,
            iconsColor: Colors.white,
            progressBarBackgroundColor: Colors.white.withValues(alpha: 0.3),
            progressBarBufferedColor: Colors.white.withValues(alpha: 0.5),
            progressBarPlayedColor: Colors.white,
            progressBarHandleColor: Colors.white,
            loadingColor: Colors.white,
            enableProgressText: true,
            enableProgressBar: true,
            enableProgressBarDrag: true,
            enableAudioTracks: false,
            enableSubtitles: false,
            enableQualities: false,
            enablePlaybackSpeed: false,
          ),
          placeholder: Container(color: Colors.black),
          showPlaceholderUntilPlay: true,
        );

    // Initialize BetterPlayerController with the data source and configuration
    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(top: 10),
      color: Colors.black,
      child: _isInitialized && _betterPlayerController != null
          ? BetterPlayer(controller: _betterPlayerController!)
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
    );
  }
}
