import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/ai_video_player.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/analyze_widget.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/top_header.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/user_review_card.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/user_review_carousel.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/video_preview.dart';
import 'package:gymm_ai_landing_page/utils/screenutil_clamp_extensions.dart';
import 'package:gymm_ai_landing_page/widgets/shinning_button.dart';
import 'package:gymm_ai_landing_page/pages/legal_doc_page.dart';

const double kHeaderHeight = 70;

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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _BlurHeaderDelegate(),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                                maxWidth: 501,
                              ),
                              child: Text(
                                'Your personal AI fitness coach',
                                style: TextStyle(
                                  fontFamily: 'Suisse',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 72.0,
                                  height: 69.8 / 72.0,
                                  letterSpacing: 0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 379,
                                minWidth: 250,
                              ),
                              child: SelectableText.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Record. Analyze. Improve. ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
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
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Suisse',
                                        letterSpacing: 0,
                                        height: 26.0 / 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 33,
                            ),
                            Row(
                              children: [
                                ShinningButton(
                                  onPressed: () {},
                                  text: 'Download for iPhone',
                                  iconUrl: 'assets/png/apple.svg',
                                ),
                                SizedBox(width: 18),
                                ShinningButton(
                                  onPressed: () {},
                                  text: 'Download for Android',
                                  iconUrl: 'assets/png/android.svg',
                                )
                              ],
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
                SizedBox(height: 100),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 634,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        'Introduction',
                        style: TextStyle(
                          fontFamily: 'Suisse',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 41 / 16,
                          letterSpacing: 0,
                          color: Color.fromRGBO(132, 131, 148, 1),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SelectableText.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Suisse',
                            fontWeight: FontWeight.w500,
                            fontSize: 40,
                            height: 50 / 40,
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
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
                MarketingPagePaddingWiget(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 495,
                          ),
                          child: SelectableText(
                            'The future of personal training',
                            style: TextStyle(
                              fontFamily: 'Suisse',
                              fontWeight: FontWeight.w500,
                              fontSize: 52.09,
                              height: 54.8 / 52.09,
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 46),
                MarketingPagePaddingWiget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DashCard(
                        width: 456,
                        height: 407,
                        backgroundColor: Color.fromRGBO(5, 12, 34, 1),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 180,
                                width: 180,
                                child: AiVideoPlayer(height: 180, width: 180),
                              ),
                              SizedBox(height: 12),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 362,
                                ),
                                child: SelectableText.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Powered by Gymm AI, built on the most advanced models',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Suisse',
                                          height: 26 / 20,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '  trained to understand your fitness workouts and deliver the most useful feedback.',
                                        style: TextStyle(
                                          color: Color(0xff7A7A7A),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Suisse',
                                          height: 26 / 20,
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
                      SizedBox(width: 24),
                      DashCard(
                        width: 648,
                        height: 407,
                        backgroundColor: Color.fromRGBO(42, 28, 67, 0.5),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 42, top: 35),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 242,
                                  ),
                                  child: SelectableText.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'Gymm reviews your workout video.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
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
                                            fontSize: 22,
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
                                    right: 57,
                                  ),
                                  child: Container(
                                    height: 293,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black.withOpacity(0.1)),
                                    child:
                                        AnalyzeWidget(width: 215, height: 293),
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
                SizedBox(height: 24),
                MarketingPagePaddingWiget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          DashCard(
                            width: 1128,
                            height: 503,
                            backgroundColor: Color.fromRGBO(38, 41, 62, 0.5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 46, top: 46),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 292,
                                    ),
                                    child: SelectableText.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'Gymm reviews your workout video.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
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
                                              fontSize: 22,
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
                            top: 52,
                            right: 72,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/png/movement.svg',
                                  height: 158,
                                  width: 228,
                                ),
                                Transform.translate(
                                  offset: Offset(-12, 0),
                                  child: SvgPicture.asset(
                                    'assets/png/technique.svg',
                                    height: 158,
                                    width: 228,
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
                                height: 260,
                                width: 393,
                              )),
                          Positioned(
                            top: 52 + 158 + 12,
                            right: 42,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/png/stability.svg',
                                  height: 158,
                                  width: 228,
                                ),
                                Transform.translate(
                                  offset: Offset(-12, 0),
                                  child: SvgPicture.asset(
                                    'assets/png/motion.svg',
                                    height: 158,
                                    width: 228,
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
                SizedBox(height: 24),
                MarketingPagePaddingWiget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DashCard(
                        width: 360,
                        height: 263,
                        backgroundColor: Color.fromRGBO(37, 35, 50, 0.7),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // 👈 pushes icon & text apart
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 48 / 2,
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  'assets/png/balance.svg',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 36, left: 38),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 239,
                                    ),
                                    child: SelectableText.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Over ',
                                            style: TextStyle(
                                              color: Color(0xff7A7A7A),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Suisse',
                                              letterSpacing: 0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '400+ ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Suisse',
                                              letterSpacing: 0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'supported exercises',
                                            style: TextStyle(
                                              color: Color(0xff7A7A7A),
                                              fontSize: 20,
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      DashCard(
                        width: 360,
                        height: 263,
                        backgroundColor: Color.fromRGBO(36, 45, 63, 0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 36 / 2,
                            ),
                            Center(
                              child: SvgPicture.asset(
                                'assets/png/available.svg',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 36, left: 38),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 202,
                                  ),
                                  child: SelectableText.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Available on',
                                          style: TextStyle(
                                            color: Color(0xff7A7A7A),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Suisse',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' iOS',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Suisse',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' and ',
                                          style: TextStyle(
                                            color: Color(0xff7A7A7A),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Suisse',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' Android',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
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
                          ],
                        ),
                      ),
                      SizedBox(width: 24),
                      DashCard(
                        width: 360,
                        height: 263,
                        backgroundColor: Color.fromRGBO(29, 43, 45, 0.7),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 43 / 2,
                            ),
                            Center(
                              child: SvgPicture.asset(
                                'assets/png/secure.svg',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 36, left: 38),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 212,
                                  ),
                                  child: SelectableText.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Your data is always ',
                                          style: TextStyle(
                                            color: Color(0xff7A7A7A),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Suisse',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'secure',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
                MarketingPagePaddingWiget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 418,
                      ),
                      child: SelectableText(
                        'What our users are saying',
                        style: TextStyle(
                          fontFamily: 'Suisse',
                          fontWeight: FontWeight.w500,
                          fontSize: 52.09,
                          height: 54.8 / 52.09,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 31),
                MarketingPagePaddingWiget(
                  child: UserReviewsCarousel(),
                ),
                SizedBox(height: 200),
                SizedBox(
                  height: 1024.h,
                  width: 1440.w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        height: 1024.h,
                        width: 1440.w,
                        'assets/png/bottom_image.png',
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                        bottom: 0,
                        child: IgnorePointer(
                          child: Container(
                            width: 1440,
                            height: 433,
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
                        bottom: -50,
                        left: 0,
                        right: 0,
                        child: Opacity(
                          opacity: 0.1,
                          child: Image.asset(
                            'assets/png/big_logo.png',
                            height: 176.33.h,
                            width: 787.86.w,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: SelectableText(
                                    'Start today',
                                    style: TextStyle(
                                      fontFamily: 'Suisse',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.09,
                                      height: 41.8 / 16.09,
                                      letterSpacing: 0,
                                      color: Color.fromRGBO(132, 131, 148, 1),
                                    ),
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 744,
                                  ),
                                  child: SelectableText(
                                    'Gymm. Your fintess coach, powered by AI',
                                    style: TextStyle(
                                      fontFamily: 'Suisse',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 72,
                                      height: 69.8 / 72,
                                      letterSpacing: 0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32),
                                ShinningButton(
                                  onPressed: () {},
                                  text: 'Download',
                                  iconUrl: 'assets/png/apple.svg',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
                FooterWidget(),
                SizedBox(height: 30),
                MarketingPagePaddingWiget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
                        '©2025 Gymm',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                          height: 21 / 14,
                          color: Color.fromRGBO(157, 157, 157, 1),
                        ),
                      ),
                      SelectableText(
                        'Made with love in Prague',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                          height: 21 / 14,
                          color: Color.fromRGBO(157, 157, 157, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => kHeaderHeight;

  @override
  double get maxExtent => kHeaderHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 30,
          sigmaY: 30,
        ),
        child: Container(
          height: kHeaderHeight,
          color: const Color.fromRGBO(0, 0, 0, 0.7),
          child: Align(
            alignment: Alignment.center,
            child: MarketingPagePaddingWiget(
              child: const TopHeader(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketingPagePaddingWiget(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
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
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                _FooterLink(
                  text: 'Download app',
                  onTap: () {
                    // TODO: Add download app functionality
                  },
                ),
                SizedBox(height: 12),
                _FooterLink(
                  text: 'Press kit',
                  onTap: () {
                    // TODO: Add press kit functionality
                  },
                ),
                SizedBox(height: 12),
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
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                _FooterLink(
                  text: 'X (Twitter)',
                  onTap: () {
                    // TODO: Add Twitter link
                  },
                ),
                SizedBox(height: 12),
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
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 12),
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
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 1170, // 1130 + 40 padding
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    );
  }
}
