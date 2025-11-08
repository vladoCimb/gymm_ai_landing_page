import 'package:ai_glow/ai_glow.dart';
import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/analyze_bar.dart';

class AnalyzeWidget extends StatefulWidget {
  const AnalyzeWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<AnalyzeWidget> createState() => _AnalyzeWidgetState();
}

class _AnalyzeWidgetState extends State<AnalyzeWidget>
    with TickerProviderStateMixin {
  late final AnimationController _analyzerController;
  late final Animation<double> _analyzerPosition;

  @override
  void initState() {
    super.initState();

    _analyzerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _analyzerPosition = Tween<double>(
      begin: -0.15, // start slightly off-screen to the left
      end: 1.3, // end slightly off-screen to the right
    ).animate(
      CurvedAnimation(
        parent: _analyzerController,
        curve: const Cubic(0.0, 0.0, 0.19, 0.98),
      ),
    );

    // start looping after small delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _analyzerController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _analyzerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InnerAiGlowing(
      height: widget.height,
      width: widget.width,
      colors: const [
        Color.fromRGBO(134, 219, 255, 1),
        Color.fromRGBO(53, 55, 191, 1),
        Color.fromRGBO(160, 0, 228, 1),
        Color.fromRGBO(0, 171, 228, 1),
        Color.fromRGBO(206, 228, 0, 1),
      ],
      glowWidth: 4,
      blure: 8,
      borderRadius: 20,
      child: Stack(
        children: [
          // scanning bar moving left → right
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _analyzerPosition,
              builder: (context, _) {
                final barWidth = widget.width * 0.384;

                // Instead of rebuilding layout with Positioned each frame,
                // we just paint the bar translated.
                final dx = _analyzerPosition.value * widget.width - barWidth;

                return Transform.translate(
                  offset: Offset(dx, 0),
                  child: SizedBox(
                    width: barWidth,
                    height: widget.height,
                    child: AnalyzerBar(
                      width: barWidth,
                      height: widget.height,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
