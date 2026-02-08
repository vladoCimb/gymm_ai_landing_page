import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AiVideoPlayer extends StatefulWidget {
  const AiVideoPlayer({
    super.key,
    required this.height,
    required this.width,
    this.onControllerReady,
  });

  final double height;
  final double width;

  /// Exposes the internal VideoPlayerController to the parent
  /// once it is initialized and ready.
  final void Function(VideoPlayerController controller)? onControllerReady;

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

  Future<void> _initializeAIAnimation() async {
    // Don't reinitialize if already initialized
    if (_controller != null && _controller!.value.isInitialized) {
      return;
    }

    // Dispose existing controller if it exists
    if (_controller != null) {
      try {
        await _controller!.dispose();
      } catch (e) {
        // ignore, just log
        // ignore: avoid_print
        print('Error disposing AI animation controller: $e');
      }
      _controller = null;
    }

    try {
      _controller = VideoPlayerController.asset('assets/png/ai_video.mp4');
      await _controller!.setVolume(0);
      await _controller!.initialize();
      await _controller!.setLooping(true);

      // Notify parent that controller is ready
      widget.onControllerReady?.call(_controller!);

      // Add listener for video state changes
      _controller!.addListener(() {
        if (mounted && _controller != null) {
          setState(() {});
        }
      });

      // Handle autoplay (web may restrict this)
      try {
        await _controller!.play();
      } catch (playError) {
        // ignore: avoid_print
        print('Autoplay failed (this is normal on web): $playError');
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // ignore: avoid_print
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
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: VideoPlayer(_controller!),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
