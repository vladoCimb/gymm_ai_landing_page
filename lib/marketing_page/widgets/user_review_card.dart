import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card.dart';
import 'package:gymm_ai_landing_page/utils/screenutil_clamp_extensions.dart';

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
          width: 360.wc,
          height: 263.hc,
          backgroundColor: const Color.fromRGBO(28, 31, 36, 0.7),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.wc, vertical: 35.hc),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SelectableText(
                review,
                style: TextStyle(
                  fontFamily: 'Suisse',
                  fontWeight: FontWeight.w400,
                  fontSize: 22.spc,
                  height: 22.spc / 22.spc,
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 13.hc),
        Padding(
          padding: EdgeInsets.only(left: 4.wc),
          child: SelectableText(
            name,
            style: TextStyle(
              fontFamily: 'Suisse',
              fontWeight: FontWeight.w500,
              fontSize: 18.spc,
              height: 24.spc / 18.spc,
              letterSpacing: 0,
              color: Color.fromRGBO(132, 131, 148, 1),
            ),
          ),
        )
      ],
    );
  }
}
