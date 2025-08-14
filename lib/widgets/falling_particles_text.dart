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

  static const double _baseDropDurationSeconds = 4.0;

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

      bool changed = false;
      for (int i = 0; i < _particles.length; i++) {
        final p = _particles[i];
        p.age += (dt / _baseDropDurationSeconds) * p.speedFactor;
        if (p.age >= 1.0) {
          _particles[i] =
              _spawnParticle(textWidth: _textSize!.width, randomizeAge: false);
          changed = true;
        } else {
          changed = true;
        }
      }
      if (changed && mounted) setState(() {});
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
      speedFactor: 0.7 + _random.nextDouble() * 0.9,
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

    return SizedBox(
      width: textW,
      height: textH,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(widget.text, style: widget.textStyle),
          Positioned(
            left: 0,
            top: textH - 10,
            child: SizedBox(
              width: textW,
              height: widget.dropHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: _particles.map((p) {
                  final double y = p.age * widget.dropHeight;
                  final double xDrift =
                      math.sin((p.age * 2 * math.pi) + p.driftSeed) * 6;
                  final double x = p.initialX + xDrift;
                  final double opacity = (1.0 - p.age).clamp(0.0, 1.0);

                  return Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 2,
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.45 * opacity),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
