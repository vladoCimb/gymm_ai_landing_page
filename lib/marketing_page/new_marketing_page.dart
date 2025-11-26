import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:flutter_svg/svg.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/ai_video_player.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card_with_analyze_and_reflection.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card_with_video_and_reflection_text.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/top_header.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/user_review_carousel.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/scroll_animated_rich_text.dart';
import 'package:gymm_ai_landing_page/widgets/black_shinning_button.dart';
import 'package:gymm_ai_landing_page/widgets/shinning_button.dart';
import 'package:gymm_ai_landing_page/pages/legal_doc_page.dart';

const double kHeaderHeight = 70;

class NewMarketingPage extends StatefulWidget {
  const NewMarketingPage({super.key});

  @override
  State<NewMarketingPage> createState() => _NewMarketingPageState();
}

class _NewMarketingPageState extends State<NewMarketingPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildDownloadButtons(BuildContext context) {
    final bool isMobileDevice = isMobile(context);

    // On mobile, show only the platform-specific button
    if (isMobileDevice) {
      // Detect platform from user agent on web
      bool isIOS = false;
      bool isAndroid = false;

      if (kIsWeb) {
        final userAgent = html.window.navigator.userAgent.toLowerCase();
        isIOS = userAgent.contains('iphone') ||
            userAgent.contains('ipad') ||
            userAgent.contains('ipod');
        isAndroid = userAgent.contains('android');
      }

      if (isIOS) {
        return ShinningButton(
          onPressed: () {},
          text: 'Download for iPhone',
          iconUrl: 'assets/png/apple.svg',
        );
      } else if (isAndroid) {
        return BlackShinningButton(
          onPressed: () {},
          text: 'Get it for Android',
          iconUrl: 'assets/png/android.svg',
        );
      } else {
        // For other platforms on mobile, show both buttons
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShinningButton(
              onPressed: () {},
              text: 'Download for iPhone',
              iconUrl: 'assets/png/apple.svg',
            ),
            SizedBox(width: 18),
            BlackShinningButton(
              onPressed: () {},
              text: 'Get it for Android',
              iconUrl: 'assets/png/android.svg',
            )
          ],
        );
      }
    }

    // On desktop/tablet, show both buttons
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShinningButton(
          onPressed: () {},
          text: 'Download for iPhone',
          iconUrl: 'assets/png/apple.svg',
        ),
        SizedBox(width: 18),
        BlackShinningButton(
          onPressed: () {},
          text: 'Get it for Android',
          iconUrl: 'assets/png/android.svg',
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _BlurHeaderDelegate(),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
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
                                    maxWidth: isMobile(context) ? 325 : 545,
                                  ),
                                  child: Text(
                                    'Your personal AI fitness coach',
                                    style: TextStyle(
                                      fontFamily: 'Suisse',
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          isMobile(context) ? 48.88 : 82.0,
                                      height: isMobile(context)
                                          ? 41.6 / 48.88
                                          : 69.8 / 82.0,
                                      letterSpacing: 0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: isMobile(context) ? 24 : 32,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: isMobile(context) ? 344 : 379,
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
                                _buildDownloadButtons(context)
                              ],
                            ),
                            Flexible(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: isMobile(context) ? 346 : 634,
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
                        height: isMobile(context) ? 0 : 10,
                      ),
                      ScrollAnimatedRichText(
                        scrollController: _scrollController,
                        text:
                            'Gymm reviews your workout video, spots what a mirror or tracker can’t, and gives you one clear cue to fix on the next rep. Mistakes aren’t failures, they’re information. Small adjustments, repeated, become real progress',
                        style: TextStyle(
                          fontFamily: 'Suisse',
                          fontWeight: FontWeight.w500,
                          fontSize: isMobile(context) ? 24 : 40,
                          height: isMobile(context) ? 30 / 24 : 50 / 40,
                          letterSpacing: 0,
                          color: const Color(0xFF848394),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: isMobile(context) ? 100 : 200,
                ),
                MarketingPagePaddingWiget(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isMobile(context) ? 346 : 495,
                          ),
                          child: SelectableText(
                            'The future of personal training',
                            style: TextStyle(
                              fontFamily: 'Suisse',
                              fontWeight: FontWeight.w500,
                              fontSize: isMobile(context) ? 36 : 52.09,
                              height:
                                  isMobile(context) ? 38 / 36 : 54.8 / 52.09,
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile(context) ? 30 : 46),
                MarketingPagePaddingWiget(
                  child: isMobile(context)
                      ? Column(
                          children: [
                            DashCardWithVideoAndReflectionText(),
                            SizedBox(height: 16),
                            DashCardWithAnalyzeAndReflectionText(),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DashCardWithVideoAndReflectionText(),
                            SizedBox(width: 24),
                            DashCardWithAnalyzeAndReflectionText(),
                          ],
                        ),
                ),
                SizedBox(height: 24),
                MarketingPagePaddingWiget(
                  child: isMobile(context)
                      ? Stack(
                          children: [
                            DashCard(
                              width: 370,
                              height: 435,
                              backgroundColor: Color.fromRGBO(38, 41, 62, 0.5),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 32, top: 32, right: 45),
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
                                            fontSize: 16,
                                            height: 21 / 16,
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
                                            fontSize: 16,
                                            height: 21 / 16,
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
                            Positioned(
                              top: 163,
                              left: 23,
                              child: Image.asset(
                                'assets/png/statistics.png',
                                height: 300,
                                width: 500,
                              ),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                DashCard(
                                  width: 1128,
                                  height: 503,
                                  backgroundColor:
                                      Color.fromRGBO(38, 41, 62, 0.5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 40, top: 40),
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
                                                    fontSize: 20,
                                                    height: 26 / 20,
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
                                                    fontSize: 20,
                                                    height: 26 / 20,
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
                                  bottom: 0,
                                  right: 50,
                                  child: Image.asset(
                                    'assets/png/statistics.png',
                                    height: 419,
                                    width: 749,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                ),
                SizedBox(height: isMobile(context) ? 16 : 24),
                MarketingPagePaddingWiget(
                  child: isMobile(context)
                      ? Column(
                          children: [
                            DashCard(
                              width: 370,
                              height: 152,
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
                                      padding:
                                          EdgeInsets.only(bottom: 32, left: 0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SelectableText.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Over ',
                                                style: TextStyle(
                                                  color: Color(0xff7A7A7A),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  height: 21 / 16,
                                                  fontFamily: 'Suisse',
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '400+ ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  height: 21 / 16,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Suisse',
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'supported exercises',
                                                style: TextStyle(
                                                  color: Color(0xff7A7A7A),
                                                  fontSize: 16,
                                                  height: 21 / 16,
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
                            ),
                            SizedBox(height: 16),
                            DashCard(
                              width: 370,
                              height: 152,
                              backgroundColor: Color.fromRGBO(36, 45, 63, 0.5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    padding: EdgeInsets.only(
                                      bottom: 32,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SelectableText.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Available on',
                                              style: TextStyle(
                                                color: Color(0xff7A7A7A),
                                                fontSize: 16,
                                                height: 21 / 20,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Suisse',
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' iOS',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                height: 21 / 20,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Suisse',
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' and ',
                                              style: TextStyle(
                                                color: Color(0xff7A7A7A),
                                                fontSize: 16,
                                                height: 21 / 20,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Suisse',
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' Android',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                height: 21 / 20,
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
                            SizedBox(height: 16),
                            DashCard(
                              width: 370,
                              height: 152,
                              backgroundColor: Color.fromRGBO(29, 43, 45, 0.7),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    padding: EdgeInsets.only(bottom: 32),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SelectableText.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Your data is always ',
                                              style: TextStyle(
                                                color: Color(0xff7A7A7A),
                                                fontSize: 16,
                                                height: 21 / 20,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Suisse',
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'secure',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                height: 21 / 20,
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
                          ],
                        )
                      : Row(
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
                                      padding:
                                          EdgeInsets.only(bottom: 36, left: 40),
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
                                                    height: 26 / 20,
                                                    fontFamily: 'Suisse',
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '400+ ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    height: 26 / 20,
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
                                                    height: 26 / 20,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    padding:
                                        EdgeInsets.only(bottom: 36, left: 40),
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
                                                  height: 26 / 20,
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
                                                  height: 26 / 20,
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
                                                  height: 26 / 20,
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
                                                  height: 26 / 20,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    padding:
                                        EdgeInsets.only(bottom: 36, left: 40),
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
                                                  height: 26 / 20,
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
                                                  height: 26 / 20,
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
                  height: isMobile(context) ? 74 : 200,
                ),
                MarketingPagePaddingWiget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isMobile(context) ? 289 : 418,
                      ),
                      child: SelectableText(
                        'What our users are saying',
                        style: TextStyle(
                          fontFamily: 'Suisse',
                          fontWeight: FontWeight.w500,
                          fontSize: isMobile(context) ? 36 : 52.09,
                          height: isMobile(context) ? 38 / 36 : 54.8 / 52.09,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 31),
                MarketingPagePaddingWiget(
                    child: UserReviewsCarousel(isMobile: isMobile(context))),
                SizedBox(height: isMobile(context) ? 74 : 200),
                SizedBox(
                  height: isMobile(context) ? 692 : 1024.h,
                  width: isMobile(context) ? 1012 : 1440.w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        height: isMobile(context) ? 1012 : 1024.h,
                        width: isMobile(context) ? 692 : 1440.w,
                        'assets/png/bottom_image.png',
                        fit: isMobile(context)
                            ? BoxFit.fitHeight
                            : BoxFit.fitWidth,
                      ),
                      Positioned(
                        bottom: 0,
                        child: IgnorePointer(
                          child: Container(
                            width: 1440,
                            height: isMobile(context) ? 180 : 433,
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
                        bottom: isMobile(context) ? 30 : -50,
                        left: 0,
                        right: 0,
                        child: Opacity(
                          opacity: 0.1,
                          child: Image.asset(
                            'assets/png/big_logo.png',
                            height: isMobile(context) ? 73 : 176.33.h,
                            width: isMobile(context) ? 326 : 787.86.w,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ).copyWith(
                            bottom: isMobile(context) ? 150 : 0,
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: isMobile(context) ? 0 : 10,
                                  ),
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
                                    'Gymm.${isMobile(context) ? '\n' : ' '}Your fitness coach, powered by AI',
                                    style: TextStyle(
                                      fontFamily: 'Suisse',
                                      fontWeight: FontWeight.w500,
                                      fontSize: isMobile(context) ? 36 : 72,
                                      height: isMobile(context)
                                          ? 41 / 36
                                          : 69.8 / 72,
                                      letterSpacing: 0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: isMobile(context) ? 28 : 32),
                                _buildDownloadButtons(context)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile(context) ? 0 : 100),
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
    final bool isMobileDevice = isMobile(context);

    // Company column widget
    final companyColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
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
    );

    // Social column widget
    final socialColumn = Column(
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
    );

    // Legal column widget
    final legalColumn = Column(
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
                    (context, animation, secondaryAnimation, child) => child,
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
                    (context, animation, secondaryAnimation, child) => child,
              ),
            );
          },
        ),
      ],
    );

    return MarketingPagePaddingWiget(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isMobileDevice ? 40 : 80),
        child: isMobileDevice
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      companyColumn,
                      SizedBox(width: 100),
                      socialColumn,
                    ],
                  ),
                  SizedBox(height: 40),
                  legalColumn,
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  companyColumn,
                  socialColumn,
                  legalColumn,
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
    final deviceType = getDeviceType(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: deviceType == DeviceType.desktop
            ? 1170 // 1130 + 40 padding
            : MediaQuery.of(context).size.width,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    );
  }
}
