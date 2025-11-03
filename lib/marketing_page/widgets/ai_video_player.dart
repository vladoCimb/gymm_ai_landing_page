import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AiVideoPlayer extends StatefulWidget {
  const AiVideoPlayer({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  State<AiVideoPlayer> createState() => _AiVideoPlayerState();
}

class _AiVideoPlayerState extends State<AiVideoPlayer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeAIAnimation();
  }

  void _initializeAIAnimation() async {
    // Don't reinitialize if already initialized
    if (_controller != null && _controller!.value.isInitialized) {
      return;
    }

    // Dispose existing controller if it exists
    if (_controller != null) {
      try {
        await _controller!.dispose();
      } catch (e) {
        print('Error disposing AI animation controller: $e');
      }
      _controller = null;
    }

    try {
      _controller = VideoPlayerController.asset('assets/png/ai_animation.mp4');
      await _controller!.setVolume(0);
      await _controller!.initialize();
      await _controller!.setLooping(true);

      // Add listener for video state changes
      _controller!.addListener(() {
        if (mounted && _controller != null) {
          setState(() {});
        }
      }); // For web, we need to handle autoplay restrictions
      try {
        await _controller!.play();
      } catch (playError) {
        print('Autoplay failed (this is normal on web): $playError');
        // On web, autoplay might fail due to browser restrictions
        // The video will still be ready to play when user interacts
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing AI animation: $e');
      _controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: VideoPlayer(_controller!),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
