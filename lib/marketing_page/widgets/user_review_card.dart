import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/marketing_page/new_marketing_page.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card.dart';
import 'package:gymm_ai_landing_page/utils/screenutil_clamp_extensions.dart';
import 'package:gymm_ai_landing_page/widgets/text_button.dart';

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
          width: 360,
          height: 263,
          backgroundColor: dashCardBackgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SelectableText(
                review,
                style: TextStyle(
                  fontFamily: 'Suisse',
                  fontWeight: FontWeight.w400,
                  fontSize: isMobile(context) ? 16 : 20,
                  height: isMobile(context) ? 21 / 16 : 26 / 20,
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 13),
        Padding(
          padding: EdgeInsets.only(left: 4),
          child: HoverableTextButton(
            onPressed: () {},
            text: name,
            style: TextStyle(
              fontFamily: 'Suisse',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 24 / 18,
              letterSpacing: 0,
              color: Color.fromRGBO(132, 131, 148, 1),
            ),
          ),
        )
      ],
    );
  }
}
