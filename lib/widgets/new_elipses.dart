import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewElipses extends StatelessWidget {
  const NewElipses({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: Opacity(
          opacity: 1,
          child: Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 62, sigmaY: 62),
                child: SvgPicture.asset(
                  'assets/png/new_elipses/1.svg',
                ),
              ),
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 134, sigmaY: 134),
                child: SvgPicture.asset(
                  'assets/png/new_elipses/2.svg',
                ),
              ),
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 54, sigmaY: 54),
                child: SvgPicture.asset(
                  'assets/png/new_elipses/3.svg',
                ),
              ),
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: SvgPicture.asset(
                  'assets/png/new_elipses/4.svg',
                ),
              ),
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: SvgPicture.asset(
                  'assets/png/new_elipses/5.svg',
                ),
              ),
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: SvgPicture.asset(
                  'assets/png/new_elipses/6.svg',
                ),
              ),
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: SvgPicture.asset(
                  'assets/png/new_elipses/7.svg',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
