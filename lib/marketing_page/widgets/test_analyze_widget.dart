import 'package:ai_glow/ai_glow.dart';
import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/video_preview.dart';

class AnalyzeBarWithPosition extends StatelessWidget {
  const AnalyzeBarWithPosition({
    super.key,
    required this.width,
    required this.height,
    required this.position,
  });

  final double width;
  final double height;
  final Animation<double> position;

  @override
  Widget build(BuildContext context) {
    return InnerAiGlowing(
      height: height,
      width: width,
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
          IgnorePointer(
            child: AnimatedBuilder(
              animation: position,
              builder: (context, _) {
                final barWidth = width * 0.384;
                final dx = position.value * width - barWidth;

                return Transform.translate(
                  offset: Offset(dx, 0),
                  child: SizedBox(
                    width: barWidth,
                    height: height,
                    child: AnalyzerBar(
                      width: barWidth,
                      height: height,
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
