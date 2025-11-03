import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymm_ai_landing_page/main.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 156.w).copyWith(top: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/png/logo.png', width: 123, height: 31),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Roadmap',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Suisse',
                  letterSpacing: 0,
                  height: 26 / 15,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                'Download',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Suisse',
                  letterSpacing: 0,
                  height: 26 / 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
