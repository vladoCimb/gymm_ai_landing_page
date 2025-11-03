import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({
    super.key,
    required this.score,
    required this.icon,
    required this.title,
    required this.colors,
  });

  final double score;
  final String icon;
  final String title;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 12,
            left: 16,
            top: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(47, 51, 66, 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: const Color.fromRGBO(255, 255, 255, 0.02), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular progress indicator with icon
              SizedBox(
                width: 38,
                height: 38,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Progress ring
                    CircleProgressBar(
                      progress: score.toDouble(),
                      size: 38,
                      strokeWidth: 3.5,
                      colors: colors,
                    ),
                    // Icon
                    SvgPicture.asset(icon),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromRGBO(159, 151, 174, 1),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  letterSpacing: 0,
                  height: 24 / 13,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '$score%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  letterSpacing: 0,
                  height: 24 / 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleProgressBar extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final List<Color> colors;
  final bool isOverallAnimatedScore;

  const CircleProgressBar({
    super.key,
    required this.progress,
    required this.size,
    required this.strokeWidth,
    required this.colors,
    this.isOverallAnimatedScore = false,
  });

  @override
  State<CircleProgressBar> createState() => _CircleProgressBarState();
}

class _CircleProgressBarState extends State<CircleProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle - only the stroke/border
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Transparent background
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 3),
                  blurRadius: 9,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: BackgroundCirclePainter(strokeWidth: widget.strokeWidth),
            ),
          ),

          // Progress Circle
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: ProgressCirclePainter(
                  progress: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  colors: widget.colors,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BackgroundCirclePainter extends CustomPainter {
  final double strokeWidth;

  BackgroundCirclePainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Border paint (for inner & outer)
    final borderPaint = Paint()
      ..color = const Color.fromRGBO(124, 124, 124, 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1; // border thickness

    // Draw outer border
    canvas.drawCircle(center, radius + strokeWidth / 2, borderPaint);

    // Draw inner border
    canvas.drawCircle(center, radius - strokeWidth / 2, borderPaint);

    // Gradient stroke paint
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(2, 1),
        end: Alignment(-2, 2.5),
        colors: [
          Color.fromRGBO(221, 229, 255, 0.12),
          Color.fromRGBO(67, 86, 255, 0.2)
        ],
        stops: [0.35, 0.6],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    // Draw gradient stroke
    canvas.drawCircle(center, radius, backgroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ProgressCirclePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;

  ProgressCirclePainter(
      {required this.progress,
      required this.strokeWidth,
      required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final sweepAngle = (progress / 100) * 2 * math.pi;
    const startAngle = math.pi / 2; // Start from bottom center

    // Add shadow effect
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = strokeWidth + 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Draw shadow
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      shadowPaint,
    );

    // Draw main progress arc in segments to create gradient effect
    final segmentCount = 100;
    final segmentAngle = sweepAngle / segmentCount;

    for (int i = 0; i < segmentCount; i++) {
      final segmentProgress = i / (segmentCount - 1);
      final currentAngle = startAngle + (i * segmentAngle);

      Color segmentColor;

      // Green to light green gradient for most of the arc
      segmentColor = Color.lerp(colors[0], colors[1], segmentProgress)!;

      final segmentPaint = Paint()
        ..color = segmentColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        segmentAngle,
        false,
        segmentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Angled extends StatelessWidget {
  const Angled({super.key, required this.angle, required this.child});

  final double angle; // radians
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      alignment: Alignment.center,
      transformHitTests: true,
      child: child,
    );
  }
}
