import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import 'dart:math' as math;

class Elipses extends StatefulWidget {
  const Elipses({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  State<Elipses> createState() => _ElipsesState();
}

class _ElipsesState extends State<Elipses> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    // Wave animation - creates gentle side-to-side movement with seamless loop
    _waveController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Float animation - creates up and down floating movement with seamless loop
    _floatController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Opacity(
        opacity: 0.44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            //  Bottom layer with gentle wave
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final waveValue = math.sin(_waveController.value * 2 * math.pi);
                return Positioned(
                  top: 0 + waveValue * 80,
                  left: 0 + waveValue * 60,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: SvgPicture.asset(
                      'assets/ellipses/bottom_one.svg',
                    ),
                  ),
                );
              },
            ),

            // Side layer with float animation -- TURN RED during redPhase
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final floatValue =
                    math.sin(_floatController.value * 2 * math.pi);
                // Smooth continuous circular transition through all colors
                final normalizedValue = _floatController.value; // 0.0 to 1.0
                Color currentColor;

                if (normalizedValue <= 0.25) {
                  // First quarter: dark blue to light blue
                  currentColor = Color.lerp(
                    const Color(0xFF0239FE), // #0239FE
                    const Color(0xFF0285FE), // #0285FE
                    normalizedValue * 4, // 0.0 to 1.0
                  )!;
                } else if (normalizedValue <= 0.75) {
                  // Middle half: light blue to red (longer red phase)
                  currentColor = Color.lerp(
                    const Color(0xFF0285FE), // #0285FE
                    Colors.red,
                    (normalizedValue - 0.25) * 2, // 0.0 to 1.0
                  )!;
                } else {
                  // Last quarter: red back to dark blue (smooth loop)
                  currentColor = Color.lerp(
                    Colors.red,
                    const Color(0xFF0239FE), // #0239FE
                    (normalizedValue - 0.75) * 4, // 0.0 to 1.0
                  )!;
                }
                return Positioned(
                  left: 0 + floatValue * 100,
                  top: -5 + floatValue * 4,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        currentColor,
                        BlendMode.srcIn,
                      ),
                      child: SvgPicture.asset(
                        'assets/ellipses/side_one.svg',
                      ),
                    ),
                  ),
                );
              },
            ),

            // Middle layer with wave -- velka machula
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final waveValue = math.sin(_waveController.value * 2 * math.pi);
                return Positioned(
                  left: 0 + waveValue * 50,
                  top: 0 + waveValue * 40,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                    child: SvgPicture.asset(
                      'assets/ellipses/middle.svg',
                    ),
                  ),
                );
              },
            ),

            //  Layer 7 with gentle float
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final floatValue =
                    math.sin(_floatController.value * 2 * math.pi);
                return Positioned(
                  top: 0 + floatValue * 60,
                  left: 0 + floatValue * 30,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 62, sigmaY: 62),
                    child: SvgPicture.asset(
                      'assets/ellipses/7.svg',
                    ),
                  ),
                );
              },
            ),

            //  Layer 6 with wave animation // big circle across whole elipses with big blurr - change to red
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final waveValue = math.sin(_waveController.value * 2 * math.pi);
                // Smooth continuous circular transition through all colors
                final normalizedValue = _waveController.value; // 0.0 to 1.0
                Color currentColor;

                if (normalizedValue <= 0.25) {
                  // First quarter: dark blue to light blue
                  currentColor = Color.lerp(
                    const Color(0xFF0239FE), // #0239FE
                    const Color(0xFF0285FE), // #0285FE
                    normalizedValue * 4, // 0.0 to 1.0
                  )!;
                } else if (normalizedValue <= 0.75) {
                  // Middle half: light blue to red (longer red phase)
                  currentColor = Color.lerp(
                    const Color(0xFF0285FE), // #0285FE
                    Colors.red,
                    (normalizedValue - 0.25) * 2, // 0.0 to 1.0
                  )!;
                } else {
                  // Last quarter: red back to dark blue (smooth loop)
                  currentColor = Color.lerp(
                    Colors.red,
                    const Color(0xFF0239FE), // #0239FE
                    (normalizedValue - 0.75) * 4, // 0.0 to 1.0
                  )!;
                }
                return Positioned(
                  top: 0 + waveValue * 70,
                  left: 0 + waveValue * 80,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 134, sigmaY: 134),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        currentColor,
                        BlendMode.srcIn,
                      ),
                      child: SvgPicture.asset(
                        'assets/ellipses/6.svg',
                      ),
                    ),
                  ),
                );
              },
            ),

            //Layer 5 with float -- TIGHT WITH side_one - big triangle
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final floatValue =
                    math.sin(_floatController.value * 2 * math.pi);
                return Positioned(
                  top: 0 + floatValue * 50,
                  left: 0 + floatValue * 40,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 54, sigmaY: 54),
                    child: SvgPicture.asset(
                      'assets/ellipses/5.svg',
                    ),
                  ),
                );
              },
            ),

            //Layer 4 with gentle wave -- BIGMIDDLE BUBBLE
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final waveValue = math.sin(_waveController.value * 2 * math.pi);
                return Positioned(
                  top: 0 + waveValue * 100,
                  left: -10 + waveValue * 0,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: SvgPicture.asset(
                      'assets/ellipses/4.svg',
                    ),
                  ),
                );
              },
            ),

            Positioned(
              top: -10,
              left: -10,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
                child: SvgPicture.asset(
                  'assets/ellipses/3.svg',
                ),
              ),
            ),

            // Layer 2 with subtle wave
            Positioned(
              top: -5,
              left: -5,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: SvgPicture.asset(
                  'assets/ellipses/2.svg',
                ),
              ),
            ),

            // Layer 1 (top) with gentle float
            Positioned(
              top: 0,
              left: 0,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: SvgPicture.asset(
                  'assets/ellipses/1.svg',
                ),
              ),
            ),

            //  Top ellipse with wave
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final waveValue = math.sin(_waveController.value * 2 * math.pi);
                return Positioned(
                  left: 0 + waveValue * 35,
                  top: 0 + waveValue * 45,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 84, sigmaY: 84),
                    child: SvgPicture.asset(
                      'assets/ellipses/top_elipse.svg',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
