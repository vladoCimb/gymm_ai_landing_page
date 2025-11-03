import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({
    super.key,
    required this.name,
    required this.review,
  });

  final String name;
  final String review;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashCard(
          width: 360.w,
          height: 263.h,
          backgroundColor: const Color.fromRGBO(28, 31, 36, 0.7),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 35.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SelectableText(
                review,
                style: TextStyle(
                  fontFamily: 'Suisse',
                  fontWeight: FontWeight.w400,
                  fontSize: 22.sp,
                  height: 22.sp / 22.sp,
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 13.h),
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: SelectableText(
            name,
            style: TextStyle(
              fontFamily: 'Suisse',
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              height: 24.sp / 18.sp,
              letterSpacing: 0,
              color: Color.fromRGBO(132, 131, 148, 1),
            ),
          ),
        )
      ],
    );
  }
}
