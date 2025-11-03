import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/ai_video_player.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/analyze_widget.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/top_header.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/user_review_card.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/video_preview.dart';
import 'package:gymm_ai_landing_page/utils/screenutil_clamp_extensions.dart';
import 'package:gymm_ai_landing_page/widgets/shinning_button.dart';
import 'package:gymm_ai_landing_page/pages/legal_doc_page.dart';

class NewMarketingPage extends StatefulWidget {
  const NewMarketingPage({super.key});

  @override
  State<NewMarketingPage> createState() => _NewMarketingPageState();
}

class _NewMarketingPageState extends State<NewMarketingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1130,
            ),
            child: Column(
              children: [
                TopHeader(),
                MarketingPagePaddingWiget(
                  child: SelectionArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 501.wc,
                              ),
                              child: Text(
                                'Your personal AI fitness coach',
                                style: TextStyle(
                                  fontFamily: 'Suisse',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 72.0.sp,
                                  height: 69.8.sp / 72.0.sp,
                                  letterSpacing: 0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32.h,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 379.w,
                                minWidth: 250.w,
                              ),
                              child: SelectableText.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Record. Analyze. Improve. ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Suisse',
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Record your training session and receive detailed improvement suggestions.',
                                      style: TextStyle(
                                        color: Color(0xff7A7A7A),
                                        fontSize: 20.0.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Suisse',
                                        letterSpacing: 0,
                                        height: 26.0.sp / 20.0.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 33.h,
                            ),
                            ShinningButton(
                              onPressed: () {},
                              text: 'Download',
                            )
                          ],
                        ),
                        Flexible(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            color: Colors.red.withOpacity(0.2),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 634.w,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          'Introduction',
                          style: TextStyle(
                            fontFamily: 'Suisse',
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            height: 41.sp / 16.sp,
                            letterSpacing: 0,
                            color: Color.fromRGBO(132, 131, 148, 1),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SelectableText.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Suisse',
                              fontWeight: FontWeight.w500,
                              fontSize: 40.sp,
                              height: 50.sp / 40.sp,
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'Gymm reviews your workout video, spots what a mirror or tracker can’t, and gives you one clear cue to fix on the next rep.\n',
                              ),
                              const TextSpan(
                                text:
                                    'Mistakes aren’t failures, they’re information. Small adjustments, repeated, become real progress.',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.6),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        )
                      ]),
                ),
                SizedBox(
                  height: 200.h,
                ),
                MarketingPagePaddingWiget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 495.w,
                      ),
                      child: SelectableText(
                        'The future of personal training',
                        style: TextStyle(
                          fontFamily: 'Suisse',
                          fontWeight: FontWeight.w500,
                          fontSize: 52.09.sp,
                          height: 54.8.sp / 52.09.sp,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 46.h),
                MarketingPagePaddingWiget(
                  child: Row(
                    children: [
                      DashCard(
                        width: 456.w,
                        height: 407.h,
                        backgroundColor: Color.fromRGBO(10, 15, 36, 0.7),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 180.h,
                                width: 180.w,
                                child:
                                    AiVideoPlayer(height: 180.h, width: 180.w),
                              ),
                              SizedBox(height: 12.h),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 362.w,
                                ),
                                child: SelectableText.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Powered by Gymm AI, built on the most advanced models',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp.clamp(2.sp, 22.sp),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Suisse',
                                          height: 26.sp / 20.sp,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '  trained to understand your fitness workouts and deliver the most useful feedback.',
                                        style: TextStyle(
                                          color: Color(0xff7A7A7A),
                                          fontSize: 20.sp.clamp(18.sp, 22.sp),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Suisse',
                                          height: 26.sp / 20.sp,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      DashCard(
                        width: 648.w,
                        height: 407.h,
                        backgroundColor: Color.fromRGBO(42, 28, 67, 0.5),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 42.w, top: 35.h),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 242.w,
                                  ),
                                  child: SelectableText.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'Gymm reviews your workout video.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Suisse',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '  Mistakes aren’t failures, they’re information. Small adjustments, repeated, become real progress.',
                                          style: TextStyle(
                                            color: Color(0xff7A7A7A),
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Suisse',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 57.w,
                                  ),
                                  child: Container(
                                    height: 293.h,
                                    width: 200.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black.withOpacity(0.1)),
                                    child: AnalyzeWidget(
                                        width: 215.w, height: 293.h),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                MarketingPagePaddingWiget(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          DashCard(
                            width: 1128.w,
                            height: 503.h,
                            backgroundColor: Color.fromRGBO(38, 41, 62, 0.5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 46.w, top: 46.h),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 292.w,
                                    ),
                                    child: SelectableText.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'Gymm reviews your workout video.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Suisse',
                                              letterSpacing: 0,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' Mistakes aren’t failures, they’re information. Small adjustments, repeated, become real progress.',
                                            style: TextStyle(
                                              color: Color(0xff7A7A7A),
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Suisse',
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 52.h,
                            right: 72.w,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/png/movement.svg',
                                  height: 158.h,
                                  width: 228.w,
                                ),
                                Transform.translate(
                                  offset: Offset(-12.w, 0),
                                  child: SvgPicture.asset(
                                    'assets/png/technique.svg',
                                    height: 158.h,
                                    width: 228.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: SvgPicture.asset(
                                'assets/png/analysis_text_1.svg',
                                height: 260.h,
                                width: 393.w,
                              )),
                          Positioned(
                            top: 52.h + 158.h + 12.h,
                            right: 42.w,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/png/stability.svg',
                                  height: 158.h,
                                  width: 228.w,
                                ),
                                Transform.translate(
                                  offset: Offset(-12.w, 0),
                                  child: SvgPicture.asset(
                                    'assets/png/motion.svg',
                                    height: 158.h,
                                    width: 228.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                MarketingPagePaddingWiget(
                  child: Row(
                    children: [
                      DashCard(
                        width: 360.w,
                        height: 263.h,
                        backgroundColor: Color.fromRGBO(36, 45, 63, 0.5),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 36.h, left: 38.w),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 202.w,
                              ),
                              child: SelectableText.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Available on',
                                      style: TextStyle(
                                        color: Color(0xff7A7A7A),
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Suisse',
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' iOS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Suisse',
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' and ',
                                      style: TextStyle(
                                        color: Color(0xff7A7A7A),
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Suisse',
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Android',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Suisse',
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      DashCard(
                        width: 360.w,
                        height: 263.h,
                        backgroundColor: Color.fromRGBO(37, 35, 50, 0.7),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 36.h, left: 38.w),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 239.w,
                                ),
                                child: SelectableText(
                                  'Over 400+ supported exercises',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Suisse',
                                    letterSpacing: 0,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      DashCard(
                        width: 360.w,
                        height: 263.h,
                        backgroundColor: Color.fromRGBO(29, 43, 45, 0.7),
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 36.h, left: 38.w),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 212.w,
                                  ),
                                  child: SelectableText(
                                    'Your data is always secure',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Suisse',
                                      letterSpacing: 0,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 364.h),
                MarketingPagePaddingWiget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 418.w,
                      ),
                      child: SelectableText(
                        'What our users are saying',
                        style: TextStyle(
                          fontFamily: 'Suisse',
                          fontWeight: FontWeight.w500,
                          fontSize: 52.09.sp,
                          height: 54.8.sp / 52.09.sp,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 31.h),
                MarketingPagePaddingWiget(
                  child: Row(
                    children: [
                      UserReviewCard(
                        name: 'Slavo',
                        review:
                            '“This app has significantly improved my quality of life. It helped me identify small mistakes I was making that were blocking my real progress.”',
                      ),
                      SizedBox(width: 24.w),
                      UserReviewCard(
                        name: 'Martin',
                        review:
                            '“This app has significantly improved fitness game!”',
                      ),
                      SizedBox(width: 24.w),
                      UserReviewCard(
                        name: 'Jakub',
                        review:
                            '"This is by far the best app I’ve used to track my workouts - it’s clean, it’s colourful, it’s honestly the best one I’ve come across."',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 227.h),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      height: 1024.h,
                      width: 1440.w,
                      'assets/png/bottom_image.png',
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: SelectableText(
                                'Start today',
                                style: TextStyle(
                                  fontFamily: 'Suisse',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.09.sp,
                                  height: 41.8.sp / 16.09.sp,
                                  letterSpacing: 0,
                                  color: Color.fromRGBO(132, 131, 148, 1),
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 744.w,
                              ),
                              child: SelectableText(
                                'Gymm. Your fintess coach, powered by AI',
                                style: TextStyle(
                                  fontFamily: 'Suisse',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 72.sp,
                                  height: 69.8.sp / 72.sp,
                                  letterSpacing: 0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            ShinningButton(
                              onPressed: () {},
                              text: 'Download',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          width: 1440.w,
                          height: 433.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              transform:
                                  GradientRotation(13.63 * math.pi / 180),
                              colors: const [
                                Color(0xFF000000),
                                Color.fromRGBO(0, 0, 0, 0),
                              ],
                              stops: const [0.0872, 0.7574],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -100.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'GYMM',
                          style: TextStyle(
                            fontFamily: 'Suisse',
                            fontWeight: FontWeight.w500,
                            fontSize: 241.09.sp,
                            letterSpacing: 0,
                            color: Color.fromRGBO(132, 131, 148, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100.h),
                FooterWidget(),
                SizedBox(height: 30.h),
                MarketingPagePaddingWiget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
                        '©2025 Gymm',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Suisse',
                          height: 21.sp / 14.sp,
                          color: Color.fromRGBO(157, 157, 157, 1),
                        ),
                      ),
                      SelectableText(
                        'Made with love in Prague',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Suisse',
                          height: 21.sp / 14.sp,
                          color: Color.fromRGBO(157, 157, 157, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketingPagePaddingWiget(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 80.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gymm brand name

            // Company column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company',
                  style: TextStyle(
                    fontFamily: 'Suisse',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                _FooterLink(
                  text: 'Download app',
                  onTap: () {
                    // TODO: Add download app functionality
                  },
                ),
                SizedBox(height: 12.h),
                _FooterLink(
                  text: 'Press kit',
                  onTap: () {
                    // TODO: Add press kit functionality
                  },
                ),
                SizedBox(height: 12.h),
                _FooterLink(
                  text: 'Contact us',
                  onTap: () {
                    // TODO: Add contact us functionality
                  },
                ),
              ],
            ),
            // Social column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Social',
                  style: TextStyle(
                    fontFamily: 'Suisse',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                _FooterLink(
                  text: 'X (Twitter)',
                  onTap: () {
                    // TODO: Add Twitter link
                  },
                ),
                SizedBox(height: 12.h),
                _FooterLink(
                  text: 'Instagram',
                  onTap: () {
                    // TODO: Add Instagram link
                  },
                ),
              ],
            ),
            // Legal column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Legal',
                  style: TextStyle(
                    fontFamily: 'Suisse',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                _FooterLink(
                  text: 'Terms of service',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const TermsOfUsePage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                child,
                      ),
                    );
                  },
                ),
                SizedBox(height: 12.h),
                _FooterLink(
                  text: 'Privacy policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const PrivacyPolicyPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                child,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Suisse',
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: Color.fromRGBO(157, 157, 157, 1),
          ),
        ),
      ),
    );
  }
}

class MarketingPagePaddingWiget extends StatelessWidget {
  const MarketingPagePaddingWiget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: child,
    );
  }
}
