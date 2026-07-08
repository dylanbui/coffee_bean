import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:app_video_player/src/widgets/thumbnail_placeholder.dart';
import 'package:app_video_player/src/widgets/seek_overlay.dart';
// Future YouTube Support: Import youtube_player_widget.dart here

class AppVideoPlayer extends StatefulWidget {
  final String url;
  final String? thumbnailUrl;
  final bool enableSeekOverlay;

  const AppVideoPlayer({
    super.key,
    required this.url,
    this.thumbnailUrl,
    this.enableSeekOverlay = true,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isControlsVisible = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    // Future YouTube Support: Detect YouTube URL here
    // bool isYouTube = widget.url.contains('youtube.com') || widget.url.contains('youtu.be');
    
    _initializeServerPlayer();
  }

  Future<void> _initializeServerPlayer() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    
    // Khởi tạo để load frame đầu tiên
    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      allowedScreenSleep: false, // Chống tắt màn hình
      placeholder: ThumbnailPlaceholder(
        thumbnailUrl: widget.thumbnailUrl,
        onPlayTap: () {
          _chewieController?.enterFullScreen();
          _videoController.play();
        },
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.brown,
        handleColor: Colors.brown,
        backgroundColor: Colors.grey.withValues(alpha: 0.5),
        bufferedColor: Colors.white.withValues(alpha: 0.3),
      ),
    );

    // Xử lý tự động Play khi vào Fullscreen (Xoay ngang)
    _chewieController!.addListener(() {
      if (_chewieController!.isFullScreen && !_videoController.value.isPlaying) {
        _videoController.play();
      }
    });

    setState(() {});
  }

  void _showControlsTemporarily() {
    setState(() {
      _isControlsVisible = true;
    });
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future YouTube Support:
    // if (isYouTube) return YoutubePlayerWidget(url: widget.url);

    if (_chewieController == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.brown));
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _showControlsTemporarily,
      child: Stack(
        children: [
          Chewie(controller: _chewieController!),
          // Seek Overlay đồng bộ với controls (qua Timer giả lập)
          if (widget.enableSeekOverlay)
            Center(
              child: SeekOverlay(
                visible: _isControlsVisible,
                onForward: () {
                  final newPos = _videoController.value.position + const Duration(seconds: 10);
                  _videoController.seekTo(newPos);
                  _showControlsTemporarily(); // Reset timer khi tương tác
                },
                onRewind: () {
                  final newPos = _videoController.value.position - const Duration(seconds: 10);
                  _videoController.seekTo(newPos);
                  _showControlsTemporarily(); // Reset timer khi tương tác
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
