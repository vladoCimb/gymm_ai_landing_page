import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/ai_video_player.dart';
import 'package:video_player/video_player.dart';

class DashCardWithVideoAndReflectionText extends StatefulWidget {
  const DashCardWithVideoAndReflectionText({super.key});

  @override
  State<DashCardWithVideoAndReflectionText> createState() =>
      _DashCardWithVideoAndReflectionTextState();
}

class _DashCardWithVideoAndReflectionTextState
    extends State<DashCardWithVideoAndReflectionText> {
  VideoPlayerController? _videoController;

  void _onVideoControllerReady(VideoPlayerController controller) {
    // Avoid re-adding listener if hot reload / rebuild happens
    if (_videoController == controller) return;

    _videoController = controller;

    _videoController!.addListener(() {
      if (!mounted) return;
      // Rebuild to update reflection strength as video time changes
      setState(() {});
    });
  }

  double _computeReflectionStrength() {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return 0.0;

    final seconds = controller.value.position.inMilliseconds / 1000.0;

    // We want:
    //  0–3 s   → no color
    //  3–8 s   → color
    //  with 0.5 s smooth easing in and out
    const start = 2.0;
    const end = 10.0;
    const fade = 0.5; // seconds

    if (seconds < start || seconds > end) {
      return 0.0;
    }

    double strength;

    if (seconds < start + fade) {
      // 3.0 → 3.5: fade in 0 → 1
      strength = (seconds - start) / fade;
    } else if (seconds > end - fade) {
      // 7.5 → 8.0: fade out 1 → 0
      strength = (end - seconds) / fade;
    } else {
      // 3.5–7.5: fully on
      strength = 1.0;
    }

    return strength.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final reflectionStrength = _computeReflectionStrength();

    return Container(
      width: 456,
      height: 407,
      color: const Color.fromRGBO(3, 10, 27, 1),
      padding: const EdgeInsets.symmetric(horizontal: 40).copyWith(
        bottom: 40,
        top: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 192,
            width: 186,
            child: AiVideoPlayer(
              height: 180,
              width: 180,
              onControllerReady: _onVideoControllerReady,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 362,
            ),
            child: TextWithLeftTopEllipseReflection(
              strength: reflectionStrength,
              child: const SelectableText.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Powered by Gymm AI, built on the most advanced models',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Suisse',
                        height: 26 / 20,
                        letterSpacing: 0,
                      ),
                    ),
                    TextSpan(
                      text:
                          '  trained to understand your fitness workouts and deliver the most useful feedback.',
                      style: TextStyle(
                        color: Color(0xff7A7A7A),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Suisse',
                        height: 26 / 20,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextWithLeftTopEllipseReflection extends StatelessWidget {
  const TextWithLeftTopEllipseReflection({
    super.key,
    required this.strength, // 0.0 = off, 1.0 = full glow
    required this.child,
  });

  final double strength;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (strength <= 0.0) {
      return child;
    }

    return Stack(
      children: [
        // Base text
        child,

        // Highlight overlay, clipped only to the text glyphs
        ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) {
            final purple = const Color.fromRGBO(105, 23, 255, 1);

            return RadialGradient(
              // LEFT + TOP (ellipse “coming” from under the video)
              center: const Alignment(-0.5, -2),
              radius: 1.5,
              stops: const [0.0, 0.45, 1.0],
              colors: [
                purple.withOpacity(0.15 * strength),
                purple.withOpacity(0.6 * strength),
                purple.withOpacity(0.0),
              ],
            ).createShader(rect);
          },
          child: child,
        ),
      ],
    );
  }
}
