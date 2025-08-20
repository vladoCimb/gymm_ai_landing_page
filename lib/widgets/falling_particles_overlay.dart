import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A generic overlay that renders small falling particles from the bottom
/// edge of any given [child] widget.
///
/// The overlay does not affect the layout size of the child; particles can
/// overflow below the child bounds (clip is disabled).
class FallingParticles extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final int particleCount;
  final double dropHeight;
  final Color particleColor;
  final double particleSize;

  const FallingParticles({
    super.key,
    required this.child,
    this.enabled = true,
    this.particleCount = 15,
    this.dropHeight = 80,
    this.particleColor = Colors.white,
    this.particleSize = 2,
  });

  @override
  State<FallingParticles> createState() => _FallingParticlesState();
}

class _FallingParticlesState extends State<FallingParticles>
    with TickerProviderStateMixin {
  static const double _baseDropDurationSeconds =
      2.0; // Reduced from 4.0 to make particles fall faster

  final GlobalKey _childKey = GlobalKey();
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;
  late final math.Random _random;

  Size? _childSize;
  late List<_Particle> _particles;

  // Performance optimizations
  static const double _targetFPS = 30.0; // Limit to 30 FPS for web
  static const double _frameInterval = 1.0 / _targetFPS;
  double _accumulatedTime = 0.0;
  bool _needsUpdate = false;

  @override
  void initState() {
    super.initState();
    _random = math.Random();
    _particles = <_Particle>[];

    _ticker = createTicker(_onTick);
    if (widget.enabled) {
      _ticker.start();
      _lastTick = Duration.zero;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureChild());
  }

  @override
  void didUpdateWidget(covariant FallingParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        if (!_ticker.isActive) {
          _lastTick = Duration.zero;
          _ticker.start();
        }
      } else {
        if (_ticker.isActive) _ticker.stop();
      }
    }
    // Re-measure in case child's size changed due to different params/state
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureChild());
  }

  void _onTick(Duration elapsed) {
    if (!widget.enabled) return;

    final int deltaMicros =
        _lastTick == Duration.zero ? 0 : (elapsed - _lastTick).inMicroseconds;
    final double dt = deltaMicros <= 0 ? 0 : deltaMicros / 1e6;
    _lastTick = elapsed;
    if (_childSize == null || dt <= 0) return;

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
            _spawnParticle(width: _childSize!.width, randomizeAge: false);
        _needsUpdate = true;
      } else {
        _needsUpdate = true;
      }
    }

    // Only call setState if something actually changed
    if (_needsUpdate && mounted) setState(() {});
  }

  void _measureChild() {
    final ctx = _childKey.currentContext;
    if (ctx == null) return;
    final render = ctx.findRenderObject();
    if (render is RenderBox) {
      final size = render.size;
      if (_childSize == null || _childSize != size) {
        setState(() {
          _childSize = size;
          _particles = List.generate(
              widget.particleCount, (_) => _spawnParticle(width: size.width));
        });
      }
    }
  }

  _Particle _spawnParticle({required double width, bool randomizeAge = true}) {
    return _Particle(
      initialX: _random.nextDouble() * width,
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
    // Always build a Stack so we can overlay when size is known
    final child = KeyedSubtree(key: _childKey, child: widget.child);

    if (_childSize == null || !widget.enabled) {
      return child;
    }

    final width = _childSize!.width;
    final height = _childSize!.height;
    final particleColor = widget.particleColor;
    final particleSize = widget.particleSize;

    return RepaintBoundary(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          // Use CustomPaint for better performance instead of multiple Positioned widgets
          Positioned(
            left: 0,
            top: height,
            child: SizedBox(
              width: width,
              height: widget.dropHeight,
              child: CustomPaint(
                painter: _ParticlesPainter(
                  particles: _particles,
                  dropHeight: widget.dropHeight,
                  particleColor: particleColor,
                  particleSize: particleSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for better performance
class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double dropHeight;
  final Color particleColor;
  final double particleSize;

  _ParticlesPainter({
    required this.particles,
    required this.dropHeight,
    required this.particleColor,
    required this.particleSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = particleColor.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    for (final p in particles) {
      final double y = p.age * dropHeight;
      final double xDrift = math.sin((p.age * 2 * math.pi) + p.driftSeed) * 6;
      final double x = p.initialX + xDrift;
      final double opacity = (1.0 - p.age).clamp(0.0, 1.0);

      if (opacity > 0) {
        paint.color = particleColor.withOpacity(0.9 * opacity);
        canvas.drawCircle(Offset(x, y), particleSize / 2, paint);
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
