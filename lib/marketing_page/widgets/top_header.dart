import 'package:flutter/material.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/png/logo_new.png', width: 88.24, height: 27.09),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {},
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  'Roadmap',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    letterSpacing: 0,
                    height: 29 / 14,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            GestureDetector(
              onTap: () {},
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      center: Alignment(-0.0846, 0.66),
                      radius: 0.65,
                      colors: [
                        Color.fromRGBO(187, 205, 242, 0.16),
                        Color.fromRGBO(187, 205, 242, 0.16),
                      ],
                      stops: [
                        0.0,
                        0.9856,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(61),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.05),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                        letterSpacing: 0,
                        height: 20 / 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
