import 'dart:io';
import 'dart:math' as math;

import 'package:ai_glow/ai_glow.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({
    super.key,
  });

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;

  late AnimationController _analyzerController;
  late Animation<double> _analyzerPosition;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/png/video.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller.initialize().then((_) {
      setState(() {});
      _controller.setLooping(true);
      _controller.setVolume(0);
      _controller.play();
    });

    // Initialize analyzer animation
    _analyzerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Adjust scan speed as needed
    );

    _analyzerPosition = Tween<double>(
      begin: -0.15, // Start slightly off-screen to the left
      end: 1.3, // End slightly off-screen to the right
    ).animate(
      CurvedAnimation(
          parent: _analyzerController,
          curve: const Cubic(0.0, 0.0, 0.19, 0.98)),
    );

    // Start the analyzer animation after a delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      _analyzerController.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // _shadowController.dispose();
    // _ellipticalController.dispose();
    _analyzerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const ratio = 1 / 1;
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        final candidateH = maxW / ratio;
        late double boxW, boxH;
        if (candidateH <= maxH) {
          boxW = maxW;
          boxH = candidateH;
        } else {
          boxH = maxH;
          boxW = maxH * ratio;
        }

        return InnerAiGlowing(
          height: boxH,
          width: boxW,
          colors: [
            const Color.fromRGBO(134, 219, 255, 1),
            const Color.fromRGBO(53, 55, 191, 1),
            const Color.fromRGBO(160, 0, 228, 1),
            const Color.fromRGBO(0, 171, 228, 1),
            const Color.fromRGBO(206, 228, 0, 1),
          ],
          glowWidth: 4,
          blure: 8,
          borderRadius: 20,
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.5,
                colors: [Color(0xFF141414), Color(0xFF141414)],
                stops: [0.0, 1.0],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.5,
                  colors: [
                    Color(0x661000E4), // rgba(160, 0, 228, 0.4)
                    Color(0x001000E4), // rgba(160, 0, 228, 0)
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                        0.7582, 0.02), // 37.91% -> 0.7582, 51% -> 0.02
                    radius: 0.2788, // 27.88%
                    colors: [
                      Color(0x661D19FF), // rgba(29, 25, 255, 0.4)
                      Color(0x000400E4), // rgba(4, 0, 228, 0)
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: boxH,
                    width: boxW,
                    child: Stack(
                      children: [
                        _controller.value.isInitialized
                            ? SizedBox.expand(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _controller.value.size.width,
                                    height: _controller.value.size.height,
                                    child: VideoPlayer(_controller),
                                  ),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),

                        //  Analyzer bar
                        IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _analyzerPosition,
                            builder: (context, child) {
                              return Stack(
                                children: [
                                  // Main analyzer bar with gradient
                                  Positioned(
                                    left: _analyzerPosition.value * boxW -
                                        (boxW *
                                            0.384), // Dynamic width offset (93/242 ≈ 0.384)
                                    top: 0,
                                    bottom: 0,
                                    child: AnalyzerBar(
                                      width: boxW * 0.384,
                                      height: boxH,
                                    ), // Pass dynamic width
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Analyzer bar widget with animated particles
class AnalyzerBar extends StatefulWidget {
  final double width;
  final double height;
  const AnalyzerBar({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<AnalyzerBar> createState() => _AnalyzerBarState();
}

class _AnalyzerBarState extends State<AnalyzerBar>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late List<ParticleData> particles;
  final random = math.Random();

  @override
  void initState() {
    super.initState();

    // Create animation controller for particles
    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // Initialize particles with random positions
    particles = List.generate(150, (index) {
      return ParticleData(
        initialX: random.nextDouble() * 40 +
            (widget.width * 0.45), // Random X within first 40% of width
        initialY: random.nextDouble() *
            widget
                .height, // Random Y across height (adjust based on your needs)
        seedX: random.nextDouble(),
        seedY: random.nextDouble(),
        opacitySeed: random.nextDouble(),
      );
    });

    _particleController.repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: double.infinity,
      child: Stack(
        children: [
          // Base gradient layer
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(105, 23, 255, 0),
                  Color.fromRGBO(105, 23, 255, 1)
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),

          // White glow layer on the right edge
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  Color.fromRGBO(105, 23, 255, 0),
                  Color.fromRGBO(251, 249, 255, 0.5),
                ],
                stops: [0.0, 0.7581, 1.0],
              ),
            ),
          ),

          // Secondary white glow layer
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  Color.fromRGBO(105, 23, 255, 0),
                  Color.fromRGBO(251, 249, 255, 0.25),
                ],
                stops: [0.0, 0.8978, 1.0],
              ),
            ),
          ),

          // Animated particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return Stack(
                children: particles.map((particle) {
                  // Calculate animated position offset (max 30px from original)
                  final progress = _particleController.value;

                  // Use sine wave for smooth position changes
                  final offsetX = math.sin(progress * 2 * math.pi +
                          particle.seedX * math.pi * 2) *
                      (widget.width * 0.06); // 15px was ~6% of 242px
                  final offsetY = math.cos(progress * 2 * math.pi +
                          particle.seedY * math.pi * 2) *
                      15;

                  // Calculate opacity animation (pulsing effect)
                  final opacity = 0.2 +
                      0.7 *
                          math
                              .sin(progress * 2 * math.pi +
                                  particle.opacitySeed * math.pi)
                              .abs();

                  return Positioned(
                    left: particle.initialX + offsetX,
                    top: particle.initialY + offsetY,
                    child: Container(
                      width: 1,
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(opacity),
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(opacity * 0.5),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Data class for particle properties
class ParticleData {
  final double initialX;
  final double initialY;
  final double seedX;
  final double seedY;
  final double opacitySeed;

  ParticleData({
    required this.initialX,
    required this.initialY,
    required this.seedX,
    required this.seedY,
    required this.opacitySeed,
  });
}
