import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/marketing_page/new_marketing_page.dart';
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

    // Reflection logic - commented out
    // _videoController!.addListener(() {
    //   if (!mounted) return;
    //   // Rebuild to update reflection strength as video time changes
    //   setState(() {});
    // });
  }

  // Reflection logic - commented out
  // double _computeReflectionStrength() {
  //   final controller = _videoController;
  //   if (controller == null || !controller.value.isInitialized) return 0.0;
  //
  //   final seconds = controller.value.position.inMilliseconds / 1000.0;
  //
  //   // We want:
  //   //  0–2 s   → no gradient
  //   //  2–5 s   → gradient (fade in at start, fade out at end)
  //   const start = 2.0;
  //   const end = 5;
  //   const fade = 0.5; // Smooth fade duration
  //
  //   if (seconds < start || seconds > end) {
  //     return 0.0;
  //   }
  //
  //   double strength;
  //
  //   if (seconds < start + fade) {
  //     // 2.0 → 2.3: fade in 0 → 1
  //     strength = (seconds - start) / fade;
  //   } else if (seconds > end - fade) {
  //     // 4.7 → 5.0: fade out 1 → 0
  //     strength = (end - seconds) / fade;
  //   } else {
  //     // 2.3–4.7: fully on
  //     strength = 1.0;
  //   }
  //
  //   return strength.clamp(0.0, 1.0);
  // }

  @override
  Widget build(BuildContext context) {
    // final reflectionStrength = _computeReflectionStrength();

    return Container(
      width: isMobile(context) ? 370 : getDesktopOrTabletSize(context, 456),
      height: isMobile(context) ? 295 : getDesktopOrTabletSize(context, 407),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            getDesktopOrTabletSize(context, 20, mobileSize: 20)),
        color: dashCardBackgroundColor,
      ),
      padding: EdgeInsets.symmetric(
              horizontal: getDesktopOrTabletSize(context, 40, mobileSize: 40))
          .copyWith(
        bottom: isMobile(context) ? 30 : getDesktopOrTabletSize(context, 40),
        top: isMobile(context) ? 8 : getDesktopOrTabletSize(context, 40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height:
                isMobile(context) ? 114 : getDesktopOrTabletSize(context, 180),
            width:
                isMobile(context) ? 118 : getDesktopOrTabletSize(context, 180),
            child: AiVideoPlayer(
              height: isMobile(context)
                  ? 114
                  : getDesktopOrTabletSize(context, 180),
              width: isMobile(context)
                  ? 118
                  : getDesktopOrTabletSize(context, 180),
              onControllerReady: _onVideoControllerReady,
            ),
          ),
          SizedBox(height: getDesktopOrTabletSize(context, 12, mobileSize: 12)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: getDesktopOrTabletSize(context, 362),
            ),
            // TextWithLeftTopEllipseReflection (reflection) - commented out
            // child: TextWithLeftTopEllipseReflection(
            //   strength: reflectionStrength,
            //   child: SelectableText.rich(
            child: SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Powered by Gymm AI, built on the most advanced models',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: isMobile(context)
                          ? 16
                          : getDesktopOrTabletSize(context, 18),
                      fontWeight: FontWeight.w500,
                      height: isMobile(context)
                          ? 21 / 16
                          : getDesktopOrTabletSize(context, 24) /
                              getDesktopOrTabletSize(context, 18),
                      letterSpacing: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '  trained to understand your fitness workouts and deliver the most useful feedback.',
                    style: GoogleFonts.inter(
                      color: Color(0xff7A7A7A),
                      fontSize: isMobile(context)
                          ? 16
                          : getDesktopOrTabletSize(context, 18),
                      fontWeight: FontWeight.w500,
                      height: isMobile(context)
                          ? 21 / 16
                          : getDesktopOrTabletSize(context, 24) /
                              getDesktopOrTabletSize(context, 18),
                      letterSpacing: 0,
                    ),
                  ),
                ],
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
              center: const Alignment(-0.5, -1.6),
              radius: 0.95,
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
