import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/test_analyze_widget.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashCard(
      width: 648,
      height: 407,
      backgroundColor: const Color.fromRGBO(42, 28, 67, 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 42, top: 35),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 242,
              ),
              child: TextWithReflection(
                animation: _position,
                child: SelectableText.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Gymm reviews your workout video.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          height: 26 / 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Suisse',
                          letterSpacing: 0,
                        ),
                      ),
                      TextSpan(
                        text:
                            '  Mistakes aren’t failures, they’re information. Small adjustments, repeated, become real progress.',
                        style: TextStyle(
                          color: const Color(0xff7A7A7A),
                          fontSize: 20,
                          height: 26 / 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Suisse',
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
              padding: const EdgeInsets.only(right: 57),
              child: Container(
                height: 293,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.1),
                ),
                child: AnalyzeBarWithPosition(
                  width: 215,
                  height: 293,
                  position: _position, // <<< share animation
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
