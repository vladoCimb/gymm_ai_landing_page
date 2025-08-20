// Generic falling particles text widget (like the AI particles on sign-in)
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FallingParticlesText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final int particleCount;
  final double dropHeight;

  const FallingParticlesText({
    super.key,
    required this.text,
    required this.textStyle,
    this.particleCount = 15,
    this.dropHeight = 100,
  });

  @override
  State<FallingParticlesText> createState() => _FallingParticlesTextState();
}

class _FallingParticlesTextState extends State<FallingParticlesText>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;
  late final math.Random _random;

  Size? _textSize;
  late List<_Particle> _particles;

  // Performance optimizations
  static const double _targetFPS = 30.0; // Limit to 30 FPS for web
  static const double _frameInterval = 1.0 / _targetFPS;
  double _accumulatedTime = 0.0;
  bool _needsUpdate = false;

  static const double _baseDropDurationSeconds =
      2.0; // Reduced from 4.0 to make particles fall faster

  @override
  void initState() {
    super.initState();
    _random = math.Random();

    _ticker = createTicker((elapsed) {
      final double dt = _lastTick == Duration.zero
          ? 0
          : (elapsed - _lastTick).inMicroseconds / 1e6;
      _lastTick = elapsed;

      if (_textSize == null || dt == 0) return;

      // Accumulate time and only update at target FPS
      _accumulatedTime += dt;
      if (_accumulatedTime < _frameInterval) return;

      _accumulatedTime = 0.0;
      _needsUpdate = false;

      // Update particles
      for (int i = 0; i < _particles.length; i++) {
        final p = _particles[i];
        p.age += (dt / _baseDropDurationSeconds) * p.speedFactor;
        if (p.age >= 1.0) {
          _particles[i] =
              _spawnParticle(textWidth: _textSize!.width, randomizeAge: false);
          _needsUpdate = true;
        } else {
          _needsUpdate = true;
        }
      }

      // Only call setState if something actually changed
      if (_needsUpdate && mounted) {
        setState(() {});
      }
    });

    _ticker.start();

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureAndInit());
  }

  void _measureAndInit() {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final width = painter.size.width;

    setState(() {
      _textSize = painter.size;
      _particles = List.generate(
          widget.particleCount, (_) => _spawnParticle(textWidth: width));
    });
  }

  _Particle _spawnParticle(
      {required double textWidth, bool randomizeAge = true}) {
    return _Particle(
      initialX: _random.nextDouble() * textWidth,
      driftSeed: _random.nextDouble() * math.pi * 2,
      speedFactor: 1.2 +
          _random.nextDouble() *
              1.3, // Increased base speed and range for faster falling
      age: randomizeAge ? _random.nextDouble() : 0.0,
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_textSize == null) {
      return Text(widget.text, style: widget.textStyle);
    }

    final textW = _textSize!.width;
    final textH = _textSize!.height;

    return RepaintBoundary(
      child: SizedBox(
        width: textW,
        height: textH,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Text(widget.text, style: widget.textStyle),
            // Use CustomPaint for better performance instead of multiple Positioned widgets
            Positioned(
              left: 0,
              top: textH - 10,
              child: SizedBox(
                width: textW,
                height: widget.dropHeight,
                child: CustomPaint(
                  painter: _ParticlesPainter(
                    particles: _particles,
                    dropHeight: widget.dropHeight,
                    textWidth: textW,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for better performance
class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double dropHeight;
  final double textWidth;

  _ParticlesPainter({
    required this.particles,
    required this.dropHeight,
    required this.textWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    for (final p in particles) {
      final double y = p.age * dropHeight;
      final double xDrift = math.sin((p.age * 2 * math.pi) + p.driftSeed) * 6;
      final double x = p.initialX + xDrift;
      final double opacity = (1.0 - p.age).clamp(0.0, 1.0);

      if (opacity > 0) {
        paint.color = Colors.white.withOpacity(0.9 * opacity);
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  double initialX;
  double driftSeed;
  double speedFactor;
  double age;

  _Particle({
    required this.initialX,
    required this.driftSeed,
    required this.speedFactor,
    required this.age,
  });
}
