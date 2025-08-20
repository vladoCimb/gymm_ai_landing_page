import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';

class ElipsesWithoutAnimation extends StatelessWidget {
  const ElipsesWithoutAnimation({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: Opacity(
          opacity: 0.44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Bottom layer - static positioned
              Positioned(
                top: 0,
                left: 0,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: SvgPicture.asset(
                    'assets/ellipses/bottom_one.svg',
                  ),
                ),
              ),

              // Side layer - static positioned with blue color
              Positioned(
                left: 0,
                top: -10,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      const Color(0xFF0239FE), // Static blue color
                      BlendMode.srcIn,
                    ),
                    child: SvgPicture.asset(
                      'assets/ellipses/side_one.svg',
                    ),
                  ),
                ),
              ),

              // Middle layer - static positioned
              Positioned(
                left: 0,
                top: 0,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                  child: SvgPicture.asset(
                    'assets/ellipses/middle.svg',
                  ),
                ),
              ),

              // Layer 7 - static positioned
              Positioned(
                top: 0,
                left: 0,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 62, sigmaY: 62),
                  child: SvgPicture.asset(
                    'assets/ellipses/7.svg',
                  ),
                ),
              ),

              // Layer 6 - static positioned with blue color
              Positioned(
                top: 0,
                left: 0,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 134, sigmaY: 134),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      const Color(0xFF0239FE), // Static blue color
                      BlendMode.srcIn,
                    ),
                    child: SvgPicture.asset(
                      'assets/ellipses/6.svg',
                    ),
                  ),
                ),
              ),

              // Layer 5 - static positioned
              Positioned(
                top: 0,
                left: 0,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 54, sigmaY: 54),
                  child: SvgPicture.asset(
                    'assets/ellipses/5.svg',
                  ),
                ),
              ),

              // Layer 4 - static positioned
              Positioned(
                top: 0,
                left: -10,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: SvgPicture.asset(
                    'assets/ellipses/4.svg',
                  ),
                ),
              ),

              // Layer 3 - static positioned
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

              // Layer 2 - static positioned
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

              // Layer 1 (top) - static positioned
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

              // Top ellipse - static positioned
              Positioned(
                left: 0,
                top: 0,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 84, sigmaY: 84),
                  child: SvgPicture.asset(
                    'assets/ellipses/top_elipse.svg',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
