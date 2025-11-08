import 'dart:math' as math;
import 'package:flutter/material.dart';

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
  late final AnimationController _particleController;
  late final List<ParticleData> _particles;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();

    // controller drives particle wobble / pulse
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Pre-generate particle seeds (stable across frames)
    _particles = List.generate(150, (index) {
      return ParticleData(
        baseXFactor: 0.6 + _random.nextDouble() * 0.3, // 45% -> 70% band
        baseYFactor: _random.nextDouble(), // full height 0..1
        seedX: _random.nextDouble(),
        seedY: _random.nextDouble(),
        opacitySeed: _random.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  /// Static stack of gradients / glow that never animates.
  /// We keep this out of AnimatedBuilder so it isn't rebuilt every tick.
  Widget _staticLayers() {
    return Stack(
      children: [
        // base purple ramp
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(105, 23, 255, 0),
                Color.fromRGBO(105, 23, 255, 1),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),

        // intense edge glow
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

        // softer outer glow
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: double.infinity,
      child: Stack(
        children: [
          // static glow / gradients
          _staticLayers(),

          // animated particle layer (only this rebuilds per frame)
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: ParticlePainter(
                  particles: _particles,
                  t: _particleController.value,
                  width: widget.width,
                  height: widget.height,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<ParticleData> particles;
  final double t; // 0..1
  final double width;
  final double height;

  ParticlePainter({
    required this.particles,
    required this.t,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.plus;

    for (final p in particles) {
      // base position in *current* size
      final baseX = p.baseXFactor * width;
      final baseY = p.baseYFactor * height;

      // smooth oscillation offsets
      final offsetX = math.sin(t * 2 * math.pi + p.seedX * math.pi * 2) *
          (width * 0.06); // scales with width
      final offsetY = math.cos(t * 2 * math.pi + p.seedY * math.pi * 2) * 15.0;

      final dx = baseX + offsetX;
      final dy = baseY + offsetY;

      // pulsing brightness
      final opacity = 0.2 +
          0.7 * (math.sin(t * 2 * math.pi + p.opacitySeed * math.pi).abs());

      // glow
      paint.color = Colors.white.withOpacity(opacity * 0.3);
      canvas.drawCircle(Offset(dx, dy), 0.8, paint);

      // core
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(dx, dy), 0.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.width != width ||
        oldDelegate.height != height ||
        oldDelegate.particles != particles;
  }
}

class ParticleData {
  final double baseXFactor; // 0..1 horizontal spawn % across the bar
  final double baseYFactor; // 0..1 vertical spawn % across the bar
  final double seedX;
  final double seedY;
  final double opacitySeed;

  ParticleData({
    required this.baseXFactor,
    required this.baseYFactor,
    required this.seedX,
    required this.seedY,
    required this.opacitySeed,
  });
}
