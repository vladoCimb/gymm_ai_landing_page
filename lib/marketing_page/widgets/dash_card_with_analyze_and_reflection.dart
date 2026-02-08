import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/marketing_page/new_marketing_page.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/test_analyze_widget.dart';
import 'package:video_player/video_player.dart';

class DashCardWithAnalyzeAndReflectionText extends StatefulWidget {
  const DashCardWithAnalyzeAndReflectionText({super.key});

  @override
  State<DashCardWithAnalyzeAndReflectionText> createState() =>
      _AnalyzeCardState();
}

class _AnalyzeCardState extends State<DashCardWithAnalyzeAndReflectionText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _position;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _position = Tween<double>(
      begin: -0.15,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Cubic(0.0, 0.0, 0.19, 0.98),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _controller.repeat();
    });

    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/png/babenka.mp4');
      await _videoController!.setVolume(0);
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      _videoController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
      try {
        await _videoController!.play();
      } catch (playError) {
        print('Autoplay failed (this is normal on web): $playError');
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing video: $e');
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashCard(
      width: isMobile(context) ? 370 : getDesktopOrTabletSize(context, 648),
      height: isMobile(context) ? 496 : getDesktopOrTabletSize(context, 407),
      backgroundColor: dashCardBackgroundColor,
      child: isMobile(context)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 32, right: 19),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 319,
                    ),
                    child: TextWithReflection(
                      animation: _position,
                      child: SelectableText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Train with confidence and clarity.',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                height: 24 / 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '  Know why a rep felt off and what to change.',
                              style: GoogleFonts.inter(
                                color: const Color(0xff7A7A7A),
                                fontSize: 18,
                                height: 24 / 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                            TextSpan(
                              text: ' Gymm ',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                height: 24 / 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'turns uncertainty into clarity, so every set has purpose.',
                              style: GoogleFonts.inter(
                                color: const Color(0xff7A7A7A),
                                fontSize: 18,
                                height: 24 / 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 293,
                    width: 215,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: Stack(
                      children: [
                        if (_videoController != null &&
                            _videoController!.value.isInitialized)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _videoController!.value.size.width,
                                  height: _videoController!.value.size.height,
                                  child: VideoPlayer(_videoController!),
                                ),
                              ),
                            ),
                          ),
                        AnalyzeBarWithPosition(
                          width: 215,
                          height: 293,
                          position: _position,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: getDesktopOrTabletSize(context, 40),
                      top: getDesktopOrTabletSize(context, 38)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: getDesktopOrTabletSize(context, 242),
                    ),
                    child: TextWithReflection(
                      animation: _position,
                      child: SelectableText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Train with confidence and clarity.',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: getDesktopOrTabletSize(context, 18),
                                height: getDesktopOrTabletSize(context, 24) /
                                    getDesktopOrTabletSize(context, 18),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "  Know why a rep felt off and what to change.",
                              style: GoogleFonts.inter(
                                color: const Color(0xff7A7A7A),
                                fontSize: getDesktopOrTabletSize(context, 18),
                                height: getDesktopOrTabletSize(context, 24) /
                                    getDesktopOrTabletSize(context, 18),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                            TextSpan(
                              text: ' Gymm ',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: getDesktopOrTabletSize(context, 18),
                                height: getDesktopOrTabletSize(context, 24) /
                                    getDesktopOrTabletSize(context, 18),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "turns uncertainty into clarity, so every set has purpose.",
                              style: GoogleFonts.inter(
                                color: const Color(0xff7A7A7A),
                                fontSize: getDesktopOrTabletSize(context, 18),
                                height: getDesktopOrTabletSize(context, 24) /
                                    getDesktopOrTabletSize(context, 18),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: getDesktopOrTabletSize(context, 57)),
                    child: Container(
                      height: getDesktopOrTabletSize(context, 293),
                      width: getDesktopOrTabletSize(context, 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            getDesktopOrTabletSize(context, 20)),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: Stack(
                        children: [
                          if (_videoController != null &&
                              _videoController!.value.isInitialized)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    getDesktopOrTabletSize(context, 20)),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _videoController!.value.size.width,
                                    height: _videoController!.value.size.height,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                ),
                              ),
                            ),
                          AnalyzeBarWithPosition(
                            width: getDesktopOrTabletSize(context, 215),
                            height: getDesktopOrTabletSize(context, 293),
                            position: _position,
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

class TextWithReflection extends StatelessWidget {
  const TextWithReflection({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        // Original animation range is roughly -0.15 .. 1.3
        // We only care when the bar is actually inside its widget → clamp to [0, 1]
        double t = animation.value.clamp(0.0, 1.0);

        // We want reflection strongest when bar is in the middle (t = 0.5)
        const center = 0.2;
        const radius = 0.9;

        final dist = (t - center).abs();
        double strength = (1 - dist / radius).clamp(0.0, 1.0);

        // If bar is far from the middle → no reflection
        if (strength == 0) {
          return child;
        }

        return Stack(
          children: [
            // base text (normal)
            child,

            // highlighted text, clipped to glyphs only
            ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (rect) {
                // You set this to 1 → whole text area gets tinted by the gradient.
                // That’s fine – the ShaderMask ensures only text pixels are affected.
                const rightBandFraction = 1.0;
                final leftStop = 1.0 - rightBandFraction;

                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [
                    0.0,
                    leftStop,
                    1.0,
                  ],
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    const Color.fromRGBO(105, 23, 255, 1)
                        .withOpacity(0.4 * strength),
                  ],
                ).createShader(rect);
              },
              child: child,
            ),
          ],
        );
      },
    );
  }
}
