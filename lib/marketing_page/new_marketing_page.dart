import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card_with_analyze_and_reflection.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/dash_card_with_video_and_reflection_text.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/top_header.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/user_review_carousel.dart';
import 'package:gymm_ai_landing_page/marketing_page/widgets/scroll_animated_rich_text.dart';
import 'package:gymm_ai_landing_page/utils/screenutil_clamp_extensions.dart';
import 'package:gymm_ai_landing_page/widgets/black_shinning_button.dart';
import 'package:gymm_ai_landing_page/widgets/shinning_button.dart';
import 'package:gymm_ai_landing_page/widgets/text_button.dart'
    show HoverableTextButton;
import 'package:gymm_ai_landing_page/widgets/falling_particles_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

const double kHeaderHeight = 70;

const Color dashCardBackgroundColor = Color.fromRGBO(31, 32, 39, 0.5);

class NewMarketingPage extends StatefulWidget {
  const NewMarketingPage({super.key});

  @override
  State<NewMarketingPage> createState() => _NewMarketingPageState();
}

class _NewMarketingPageState extends State<NewMarketingPage>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;

  late AnimationController _controller;

  // Staggered Animation Intervals
  // 1. Headline: 0% to 50% of the animation duration
  late Animation<double> _headlineAnimation;
  // 2. Subtext: 40% to 70% (overlaps slightly)
  late Animation<double> _subtextAnimation;
  // 3. Buttons: 60% to 90%
  late Animation<double> _buttonAnimation;
  // 4. Video Player: 80% to 100%
  late Animation<double> _videoPlayerAnimation;

  html.EventListener? _visibilityListener;
  VideoPlayerController? _landingVideoController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1200), // Slower for dramatic effect
    );

    _headlineAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );

    _subtextAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
    );

    _buttonAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );

    _videoPlayerAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    if (kIsWeb) {
      // Check if splash screen already exists (first load) or is gone (reload/navigation)
      final splashElement = html.document.getElementById('splash');
      final isFlutterLoaded =
          html.document.body?.classes.contains('flutter-loaded') ?? false;

      // If splash is already gone or Flutter is already loaded, trigger animation immediately
      if (splashElement == null || isFlutterLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.forward(from: 0);
        });
      }

      // Always listen for the event as a fallback (in case splash is still there)
      _visibilityListener = (event) {
        _controller.forward(from: 0);
      };
      html.window.addEventListener('gymm-visible', _visibilityListener!);

      // Final fallback: if event doesn't fire within 2 seconds, trigger anyway
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 2), () {
          if (!_controller.isAnimating && _controller.value == 0) {
            _controller.forward(from: 0);
          }
        });
      });
    } else {
      // Non-web platforms: start after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward(from: 0);
      });
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Future.delayed(const Duration(milliseconds: 250), () {
    //     _controller.forward();
    //   });
    // });

    _initializeLandingVideo();
  }

  void _initializeLandingVideo() async {
    try {
      _landingVideoController =
          VideoPlayerController.asset('assets/png/video-website-with-bg.mp4');
      await _landingVideoController!.setVolume(0);
      await _landingVideoController!.initialize();
      await _landingVideoController!.setLooping(true);
      _landingVideoController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
      try {
        await _landingVideoController!.play();
      } catch (playError) {
        // ignore: avoid_print
        print(
            'Landing video autoplay failed (this is normal on web): $playError');
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error initializing landing video: $e');
      _landingVideoController = null;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _landingVideoController?.dispose();
    if (kIsWeb && _visibilityListener != null) {
      html.window.removeEventListener('gymm-visible', _visibilityListener!);
    }

    super.dispose();
  }

  Widget _buildLandingVideoPlayer(BuildContext context) {
    // If video controller is not initialized, return empty container
    if (_landingVideoController == null ||
        !_landingVideoController!.value.isInitialized) {
      return SizedBox();
    }

    // Check if video is playing, if not, try to play it
    if (_landingVideoController!.value.isInitialized &&
        !_landingVideoController!.value.isPlaying) {
      // Use a microtask to avoid calling setState during build
      Future.microtask(() {
        if (mounted &&
            _landingVideoController != null &&
            _landingVideoController!.value.isInitialized) {
          try {
            _landingVideoController!.play();
          } catch (e) {
            // ignore: avoid_print
            print('Error auto-playing landing video: $e');
          }
        }
      });
    }

    return AspectRatio(
      aspectRatio: _landingVideoController!.value.aspectRatio,
      child: VideoPlayer(_landingVideoController!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: BlurHeaderDelegate(),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (!isMobile(context))
                      Positioned(
                        right: -300,
                        top: 0,
                        child: SizedBox(
                          width: isTablet(context) ? 1200 * 0.8 : 1200,
                          height: 990,
                          child: FadeBlurReveal(
                            animation: _videoPlayerAnimation,
                            child: _buildLandingVideoPlayer(context),
                          ),
                        ),
                      ),
                    Column(
                      children: [
                        MarketingPagePaddingWiget(
                          child: SelectionArea(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: isMobile(context) ? 60 : 200.hc,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: isMobile(context)
                                            ? 325
                                            : getDesktopOrTabletSize(
                                                context, 545),
                                      ),
                                      child: FadeBlurReveal(
                                        animation: _headlineAnimation,
                                        child: SelectableText.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Suisse',
                                              fontWeight: FontWeight.w500,
                                              fontSize: isMobile(context)
                                                  ? 48.88
                                                  : getDesktopOrTabletSize(
                                                      context, 82.0),
                                              height: isMobile(context)
                                                  ? 55.55 / 48.88
                                                  : getDesktopOrTabletSize(
                                                          context, 84.8) /
                                                      getDesktopOrTabletSize(
                                                          context, 82.0),
                                              letterSpacing: 0,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: 'Camera based ',
                                              ),
                                              TextSpan(
                                                text: 'AI',
                                                style: TextStyle(
                                                  fontFamily: 'Suisse',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: isMobile(context)
                                                      ? 48.88
                                                      : getDesktopOrTabletSize(
                                                          context, 82.0),
                                                  height: isMobile(context)
                                                      ? 55.55 / 48.88
                                                      : getDesktopOrTabletSize(
                                                              context, 84.8) /
                                                          getDesktopOrTabletSize(
                                                              context, 82.0),
                                                  letterSpacing: 0,
                                                  color: Color.fromRGBO(
                                                      198, 218, 255, 1),
                                                  shadows: [
                                                    Shadow(
                                                      color:
                                                          const Color.fromRGBO(
                                                              63, 89, 255, 1),
                                                      offset: Offset(0, 0),
                                                      blurRadius: 15.96,
                                                    ),
                                                    Shadow(
                                                      color:
                                                          const Color.fromRGBO(
                                                              66, 91, 255, 1),
                                                      offset: Offset(0, 57.01),
                                                      blurRadius: 84.37,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const TextSpan(
                                                text: ' fitness coach',
                                              ),
                                              // TextSpan(
                                              //   text: 'AI fitness',
                                              //   style: TextStyle(
                                              //     fontFamily: 'Suisse',
                                              //     fontWeight: FontWeight.w500,
                                              //     fontSize: isMobile(context)
                                              //         ? 48.88
                                              //         : getDesktopOrTabletSize(
                                              //             context, 82.0),
                                              //     height: isMobile(context)
                                              //         ? 41.6 / 48.88
                                              //         : getDesktopOrTabletSize(
                                              //                 context, 84.8) /
                                              //             getDesktopOrTabletSize(
                                              //                 context, 82.0),
                                              //     letterSpacing: 0,
                                              //     color: Colors.white,
                                              //   ),
                                              // ),
                                              // TextSpan(
                                              //   text: ' coach',
                                              //   style: TextStyle(
                                              //     fontFamily: 'Suisse',
                                              //     fontWeight: FontWeight.w500,
                                              //     fontSize: isMobile(context)
                                              //         ? 48.88
                                              //         : getDesktopOrTabletSize(
                                              //             context, 82.0),
                                              //     height: isMobile(context)
                                              //         ? 41.6 / 48.88
                                              //         : getDesktopOrTabletSize(
                                              //                 context, 60.0) /
                                              //             getDesktopOrTabletSize(
                                              //                 context, 82.0),
                                              //     letterSpacing: 0,
                                              //     color: Colors.white,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: isMobile(context)
                                          ? 24
                                          : getDesktopOrTabletSize(context, 32),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: isMobile(context) ? 344 : 379,
                                        minWidth: 230,
                                      ),
                                      child: FadeBlurReveal(
                                        animation: _subtextAnimation,
                                        child: SelectableText.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'Record. Analyze. Improve. ',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  height: 26.0 / 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    'Record your training session and receive detailed improvement suggestions.',
                                                style: GoogleFonts.inter(
                                                  color: Color(0xff7A7A7A),
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0,
                                                  height: 24.0 / 18.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 33,
                                    ),
                                    FadeBlurReveal(
                                      animation: _buttonAnimation,
                                      child: DownloadButtons(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isMobile(context))
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 40,
                            ),
                            child: ClipRect(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return FractionallySizedBox(
                                    widthFactor: 1.75,
                                    alignment: Alignment.center,
                                    child: _buildLandingVideoPlayer(
                                      context,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        SizedBox(height: isMobile(context) ? 0 : 300),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: isMobile(context)
                                ? 346
                                : getDesktopOrTabletSize(context, 634),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Introduction',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  height: 41 / 18,
                                  letterSpacing: 0,
                                  color: Color.fromRGBO(132, 131, 148, 1),
                                ),
                              ),
                              SizedBox(
                                height: isMobile(context)
                                    ? 0
                                    : getDesktopOrTabletSize(context, 10),
                              ),
                              ScrollAnimatedRichText(
                                scrollController: _scrollController,
                                triggerOffset: isMobile(context)
                                    ? 100
                                    : getDesktopOrTabletSize(context, 150),
                                text:
                                    "Gymm reviews your workout videos, spots what a mirror or tracker can't, and gives you clear cues what to fix on the next rep. Mistakes aren't failures, they're information. Small adjustments, repeated, become real progress",
                                style: TextStyle(
                                  fontFamily: 'Suisse',
                                  fontWeight: FontWeight.w500,
                                  fontSize: isMobile(context)
                                      ? 24
                                      : getDesktopOrTabletSize(context, 40),
                                  height: isMobile(context)
                                      ? 30 / 24
                                      : getDesktopOrTabletSize(context, 50) /
                                          getDesktopOrTabletSize(context, 40),
                                  letterSpacing: 0,
                                  color: const Color(0xFF848394),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: isMobile(context)
                              ? 100
                              : getDesktopOrTabletSize(context, 200),
                        ),
                        MarketingPagePaddingWiget(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: isMobile(context)
                                        ? 346
                                        : getDesktopOrTabletSize(context, 495),
                                  ),
                                  child: SelectableText(
                                    'The future of personal training',
                                    style: TextStyle(
                                      fontFamily: 'Suisse',
                                      fontWeight: FontWeight.w500,
                                      fontSize: isMobile(context)
                                          ? 36
                                          : getDesktopOrTabletSize(
                                              context, 52.09),
                                      height: isMobile(context)
                                          ? 38 / 36
                                          : getDesktopOrTabletSize(
                                                  context, 54.8) /
                                              getDesktopOrTabletSize(
                                                  context, 52.09),
                                      letterSpacing: 0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                    height: isMobile(context)
                        ? 30
                        : getDesktopOrTabletSize(context, 46)),
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
                            SizedBox(
                                width: getDesktopOrTabletSize(context, 24)),
                            DashCardWithAnalyzeAndReflectionText(),
                          ],
                        ),
                ),
                SizedBox(
                    height:
                        getDesktopOrTabletSize(context, 24, mobileSize: 24)),
                MarketingPagePaddingWiget(
                  child: isMobile(context)
                      ? Stack(
                          children: [
                            DashCard(
                              width: 370,
                              height: 435,
                              backgroundColor: dashCardBackgroundColor,
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
                                          text: 'Data that actually helps.',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 18,
                                            height: 24 / 18,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' Performance scores and actionable explanations focused on real training and real results.',
                                          style: GoogleFonts.inter(
                                            color: Color(0xff7A7A7A),
                                            fontSize: 18,
                                            height: 24 / 18,
                                            fontWeight: FontWeight.w500,
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  getDesktopOrTabletSize(context, 24)),
                              child: Stack(
                                clipBehavior: Clip.antiAlias,
                                children: [
                                  DashCard(
                                    width:
                                        getDesktopOrTabletSize(context, 1128),
                                    height:
                                        getDesktopOrTabletSize(context, 503),
                                    backgroundColor: dashCardBackgroundColor,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: getDesktopOrTabletSize(
                                                  context, 40),
                                              top: getDesktopOrTabletSize(
                                                  context, 40)),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: getDesktopOrTabletSize(
                                                  context, 292),
                                            ),
                                            child: SelectableText.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'Data that actually helps.',
                                                    style: GoogleFonts.inter(
                                                      color: Colors.white,
                                                      fontSize:
                                                          getDesktopOrTabletSize(
                                                              context, 18),
                                                      height: getDesktopOrTabletSize(
                                                              context, 24) /
                                                          getDesktopOrTabletSize(
                                                              context, 18),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " Performance scores and actionable explanations focused on real training and real results.",
                                                    style: GoogleFonts.inter(
                                                      color: Color(0xff7A7A7A),
                                                      fontSize:
                                                          getDesktopOrTabletSize(
                                                              context, 18),
                                                      height: getDesktopOrTabletSize(
                                                              context, 24) /
                                                          getDesktopOrTabletSize(
                                                              context, 18),
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                    right: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(
                                            getDesktopOrTabletSize(
                                                context, 24)),
                                      ),
                                      child: Image.asset(
                                        'assets/png/statistics.png',
                                        height: getDesktopOrTabletSize(
                                            context, 419),
                                        width: getDesktopOrTabletSize(
                                            context, 749),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                    height: isMobile(context)
                        ? 16
                        : getDesktopOrTabletSize(context, 24)),
                MarketingPagePaddingWiget(
                  child: isMobile(context)
                      ? Column(
                          children: [
                            DashCard(
                              width: 370,
                              height: 152,
                              backgroundColor: dashCardBackgroundColor,
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
                              backgroundColor: dashCardBackgroundColor,
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
                                              style: GoogleFonts.inter(
                                                color: Color(0xff7A7A7A),
                                                fontSize: 18,
                                                height: 24 / 18,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' iOS',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 18,
                                                height: 24 / 18,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' and ',
                                              style: GoogleFonts.inter(
                                                color: Color(0xff7A7A7A),
                                                fontSize: 18,
                                                height: 24 / 18,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' Android',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 18,
                                                height: 24 / 18,
                                                fontWeight: FontWeight.w500,
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
                              backgroundColor: dashCardBackgroundColor,
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
                                              style: GoogleFonts.inter(
                                                color: Color(0xff7A7A7A),
                                                fontSize: 18,
                                                height: 24 / 18,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'secure',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 18,
                                                height: 24 / 18,
                                                fontWeight: FontWeight.w500,
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
                              width: getDesktopOrTabletSize(context, 360),
                              height: getDesktopOrTabletSize(context, 263),
                              backgroundColor: dashCardBackgroundColor,
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
                                      padding: EdgeInsets.only(
                                          bottom: getDesktopOrTabletSize(
                                              context, 36),
                                          left: getDesktopOrTabletSize(
                                              context, 40)),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: getDesktopOrTabletSize(
                                                context, 239),
                                          ),
                                          child: SelectableText.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Over ',
                                                  style: GoogleFonts.inter(
                                                    color: Color(0xff7A7A7A),
                                                    fontSize:
                                                        getDesktopOrTabletSize(
                                                            context, 18),
                                                    fontWeight: FontWeight.w500,
                                                    height: getDesktopOrTabletSize(
                                                            context, 24) /
                                                        getDesktopOrTabletSize(
                                                            context, 18),
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '400+ ',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontSize:
                                                        getDesktopOrTabletSize(
                                                            context, 18),
                                                    height: getDesktopOrTabletSize(
                                                            context, 24) /
                                                        getDesktopOrTabletSize(
                                                            context, 18),
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'supported exercises',
                                                  style: GoogleFonts.inter(
                                                    color: Color(0xff7A7A7A),
                                                    fontSize:
                                                        getDesktopOrTabletSize(
                                                            context, 18),
                                                    height: getDesktopOrTabletSize(
                                                            context, 24) /
                                                        getDesktopOrTabletSize(
                                                            context, 18),
                                                    fontWeight: FontWeight.w500,
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
                            SizedBox(
                                width: getDesktopOrTabletSize(context, 24)),
                            DashCard(
                              width: getDesktopOrTabletSize(context, 360),
                              height: getDesktopOrTabletSize(context, 263),
                              backgroundColor: dashCardBackgroundColor,
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
                                        bottom:
                                            getDesktopOrTabletSize(context, 36),
                                        left: getDesktopOrTabletSize(
                                            context, 40)),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: getDesktopOrTabletSize(
                                              context, 202),
                                        ),
                                        child: SelectableText.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Available on',
                                                style: GoogleFonts.inter(
                                                  color: Color(0xff7A7A7A),
                                                  fontSize:
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  height: getDesktopOrTabletSize(
                                                          context, 24) /
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' iOS',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize:
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  height: getDesktopOrTabletSize(
                                                          context, 24) /
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' and ',
                                                style: GoogleFonts.inter(
                                                  color: Color(0xff7A7A7A),
                                                  fontSize:
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  height: getDesktopOrTabletSize(
                                                          context, 24) /
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' Android',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize:
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  height: getDesktopOrTabletSize(
                                                          context, 24) /
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  fontWeight: FontWeight.w500,
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
                            SizedBox(
                                width: getDesktopOrTabletSize(context, 24)),
                            DashCard(
                              width: getDesktopOrTabletSize(context, 360),
                              height: getDesktopOrTabletSize(context, 263),
                              backgroundColor: dashCardBackgroundColor,
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
                                    padding: EdgeInsets.only(
                                        bottom:
                                            getDesktopOrTabletSize(context, 36),
                                        left: getDesktopOrTabletSize(
                                            context, 40)),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: getDesktopOrTabletSize(
                                              context, 212),
                                        ),
                                        child: SelectableText.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Your data is always ',
                                                style: GoogleFonts.inter(
                                                  color: Color(0xff7A7A7A),
                                                  fontSize:
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  height: getDesktopOrTabletSize(
                                                          context, 24) /
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'secure',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize:
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  height: getDesktopOrTabletSize(
                                                          context, 24) /
                                                      getDesktopOrTabletSize(
                                                          context, 18),
                                                  fontWeight: FontWeight.w500,
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
                  height: isMobile(context)
                      ? 74
                      : getDesktopOrTabletSize(context, 200),
                ),
                MarketingPagePaddingWiget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isMobile(context)
                            ? 289
                            : getDesktopOrTabletSize(context, 418),
                      ),
                      child: SelectableText(
                        'What our users are saying',
                        style: TextStyle(
                          fontFamily: 'Suisse',
                          fontWeight: FontWeight.w500,
                          fontSize: isMobile(context)
                              ? 36
                              : getDesktopOrTabletSize(context, 52.09),
                          height: isMobile(context)
                              ? 38 / 36
                              : getDesktopOrTabletSize(context, 54.8) /
                                  getDesktopOrTabletSize(context, 52.09),
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
                NewMarketingFooterWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewMarketingFooterWidget extends StatelessWidget {
  const NewMarketingFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height:
                isMobile(context) ? 74 : getDesktopOrTabletSize(context, 200)),
        SizedBox(
          height: isMobile(context)
              ? 692
              : (isTablet(context) ? 1024 * 0.8 : 1024.h),
          width: isMobile(context)
              ? 1012
              : (isTablet(context) ? 1440 * 0.8 : 1440.w),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                height: isMobile(context)
                    ? 1012
                    : (isTablet(context) ? 1024 * 0.8 : 1024.h),
                width: isMobile(context)
                    ? 692
                    : (isTablet(context) ? 1440 * 0.8 : 1440.w),
                'assets/png/bottom_image.png',
                fit: isMobile(context) ? BoxFit.fitHeight : BoxFit.fitWidth,
              ),
              Positioned(
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    width:
                        getDesktopOrTabletSize(context, 1440, mobileSize: 1440),
                    height: isMobile(context)
                        ? 180
                        : getDesktopOrTabletSize(context, 433),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        transform: GradientRotation(13.63 * math.pi / 180),
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
                bottom: isMobile(context)
                    ? 30
                    : (isTablet(context) ? -80 * 0.8 : -80),
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/png/big_logo.png',
                    height: isMobile(context)
                        ? 73
                        : (isTablet(context) ? 227.33 * 0.8 : 227.33.h),
                    width: isMobile(context)
                        ? 326
                        : (isTablet(context) ? 1015.86 * 0.8 : 1015.86.w),
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
                            left: isMobile(context)
                                ? 0
                                : getDesktopOrTabletSize(context, 10),
                          ),
                          child: SelectableText(
                            'Start today',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              height: 41 / 18,
                              letterSpacing: 0,
                              color: Color.fromRGBO(132, 131, 148, 1),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: getDesktopOrTabletSize(context, 800),
                          ),
                          child: SelectableText(
                            'Gymm.${isMobile(context) ? '\n' : ' '}Camera based AI fitness coach',
                            style: TextStyle(
                              fontFamily: 'Suisse',
                              fontWeight: FontWeight.w500,
                              fontSize: isMobile(context)
                                  ? 36
                                  : getDesktopOrTabletSize(context, 72),
                              height: isMobile(context)
                                  ? 41 / 36
                                  : 69.8 / getDesktopOrTabletSize(context, 72),
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: isMobile(context)
                                ? 28
                                : getDesktopOrTabletSize(context, 32)),
                        DownloadButtons()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
            height:
                isMobile(context) ? 0 : getDesktopOrTabletSize(context, 100)),
        FooterWidget(),
        SizedBox(height: 30),
        MarketingPagePaddingWiget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectableText(
                '©2025 Gymm',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 21 / 14,
                  color: Color.fromRGBO(157, 157, 157, 1),
                ),
              ),
              SelectableText(
                'Made with love in Prague',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
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
    );
  }
}

class DownloadButtons extends StatelessWidget {
  const DownloadButtons({super.key});

  @override
  Widget build(BuildContext context) {
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
          iconUrl: 'assets/png/android.png',
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
              iconUrl: 'assets/png/android.png',
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
          onPressed: () {
            showGetAppDialog(context);
          },
          text: 'Download for iPhone',
          iconUrl: 'assets/png/apple.svg',
        ),
        SizedBox(width: 18),
        BlackShinningButton(
          onPressed: () {
            showGetAppDialog(context);
          },
          text: 'Get it for Android',
          iconUrl: 'assets/png/android.png',
        ),
      ],
    );
  }
}

class BlurHeaderDelegate extends SliverPersistentHeaderDelegate {
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
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: Container(
          height: kHeaderHeight,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            boxShadow: [
              // BoxShadow(
              //   color: Color.fromRGBO(255, 255, 255, 0.1),
              //   blurRadius: 0,
              //   spreadRadius: 0,
              //   offset: Offset(0, 1),
              // ),
            ],
          ),
          child: Align(
            alignment: Alignment.center,
            child: MarketingPagePaddingWiget(
              child: TopHeader(
                onDownloadPressed: () {
                  showGetAppDialog(context);
                },
              ),
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
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        _FooterLink(
          text: 'Download app',
          onTap: () {
            showGetAppDialog(context);
          },
        ),
        SizedBox(height: 12),
        _FooterLink(
          text: 'Press kit',
          onTap: () {
            context.push('/press_kit');
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
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        // _FooterLink(
        //   text: 'X (Twitter)',
        //   onTap: () {
        //     // TODO: Add Twitter link
        //   },
        // ),
        // SizedBox(height: 12),
        _FooterLink(
          text: 'Instagram',
          onTap: () {
            launchUrl(Uri.parse('https://www.instagram.com/gymm_ai'));
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
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        _FooterLink(
          text: 'Terms of service',
          onTap: () {
            context.push('/terms_of_use');
            // Navigator.push(
            //   context,
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) =>
            //         const TermsOfUsePage(),
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) => child,
            //   ),
            // );
          },
        ),
        SizedBox(height: 12),
        _FooterLink(
          text: 'Privacy policy',
          onTap: () {
            context.push('/privacy_policy');
            // Navigator.push(
            //   context,
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) =>
            //         const PrivacyPolicyPage(),
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) => child,
            //   ),
            // );
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
                  Image.asset(
                    'assets/png/logo_new.png',
                    width: 86.24,
                    height: 27.09,
                  ),
                  SizedBox(
                    height: 34,
                  ),
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
            : Stack(
                children: [
                  Image.asset(
                    'assets/png/logo_new.png',
                    width: 86.24,
                    height: 27.09,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        companyColumn,
                        socialColumn,
                        legalColumn,
                      ],
                    ),
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
    return HoverableTextButton(
      text: text,
      onPressed: onTap,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color.fromRGBO(157, 157, 157, 1),
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
            : deviceType == DeviceType.tablet
                ? 1170 * 0.8 // 80% of desktop
                : MediaQuery.of(context).size.width,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    );
  }
}

void showGetAppDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Get the Gymm app',
    barrierColor: Colors.transparent, // we’ll draw our own overlay
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      );

      return FadeTransition(
        opacity: curved,
        child: Stack(
          children: [
            // Background overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            ),

            // Centered dialog card with scale animation
            Center(
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.95,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                    reverseCurve: Curves.easeOut,
                  ),
                ),
                child: _GetAppDialogCard(),
              ),
            ),
          ],
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}

class _GetAppDialogCard extends StatelessWidget {
  const _GetAppDialogCard();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 640,
        minWidth: 320,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff101013),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              // Close button
              Positioned(
                right: 16,
                top: 16,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),

              // Content
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Get the Gymm app',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Suisse',
                        height: 54.8 / 52,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: const Text(
                        'Scan the QR code to download the app. '
                        'Available on iOS and Android.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Suisse',
                          letterSpacing: 0,
                          height: 19 / 14,
                          color: Color.fromRGBO(165, 165, 165, 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // QR "card"
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1B23),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        // Replace with your own QR code widget / Image.asset
                        child: Image.asset(
                          'assets/png/qr_code.png',
                          width: 180,
                          height: 180,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // -----------------------------------------------------------------------------
// // WIDGET 1: Typewriter Effect with Blur
// // -----------------------------------------------------------------------------
// class TypewriterBlurReveal extends StatelessWidget {
//   final Animation<double> animation;
//   final String text;
//   final TextStyle style;

//   const TypewriterBlurReveal({
//     super.key,
//     required this.animation,
//     required this.text,
//     required this.style,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, child) {
//         // 1. Calculate how many characters to show based on animation value (0.0 to 1.0)
//         final int charCount = (text.length * animation.value).ceil();
//         final String visibleString =
//             text.substring(0, charCount.clamp(0, text.length));

//         // 2. Calculate Blur: Starts high (10.0), ends at 0.0
//         // We use a curve so it unblurs quickly at the end for readability
//         final double blurValue = (1.0 - animation.value) * 10;

//         // 3. Calculate Opacity: Starts at 0, goes to 1
//         final double opacity = animation.value.clamp(0.0, 1.0);

//         return Opacity(
//           opacity: opacity,
//           child: ImageFiltered(
//             imageFilter: ImageFilter.blur(
//               sigmaX: blurValue,
//               sigmaY: blurValue,
//             ),
//             child: Text(
//               visibleString,
//               style: style,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class TypewriterBlurReveal extends StatelessWidget {
  final Animation<double> animation;
  final String? text;
  final TextStyle? style;
  final List<({String text, TextStyle style})>? textSegments;

  /// Maximum blur when a character first appears.
  final double maxBlur;

  /// How long (fraction of total animation) each character spends going
  /// from blurred → sharp after it appears.
  final double perCharBlurFraction;

  const TypewriterBlurReveal({
    super.key,
    required this.animation,
    this.text,
    this.style,
    this.textSegments,
    this.maxBlur = 10.0,
    this.perCharBlurFraction = 0.15,
  }) : assert(
          (text != null && style != null) || textSegments != null,
          'Either provide text+style or textSegments',
        );

  @override
  Widget build(BuildContext context) {
    // Use textSegments if provided, otherwise use single text/style
    final segments = textSegments ?? [(text: text!, style: style!)];

    // Calculate total length for animation timing
    final totalLength = segments.fold<int>(
      0,
      (sum, segment) => sum + segment.text.length,
    );

    if (totalLength == 0) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value.clamp(0.0, 1.0);
        final spans = <InlineSpan>[];
        int charIndex = 0;

        for (final segment in segments) {
          final segmentLength = segment.text.length;
          final baseColor = segment.style.color ?? const Color(0xFFFFFFFF);

          for (var i = 0; i < segmentLength; i++) {
            final char = segment.text[i];

            // When this character starts and ends its blur animation
            final double appearT = charIndex / totalLength;
            final double endT = (appearT + perCharBlurFraction).clamp(0.0, 1.0);

            TextStyle charStyle;

            if (t <= appearT) {
              // Not yet "typed": invisible but still in layout
              charStyle = segment.style.copyWith(
                color: baseColor.withOpacity(0.0),
              );
            } else if (t >= endT) {
              // Fully visible, sharp
              charStyle = segment.style;
            } else {
              // In its blur → sharp phase
              final local = (t - appearT) / (endT - appearT);
              final blur = maxBlur * (1.0 - local);

              final paint = Paint()
                ..color = baseColor
                ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

              charStyle = segment.style.copyWith(
                // When foreground is set, color is ignored – everything is in paint
                foreground: paint,
              );
            }

            spans.add(TextSpan(text: char, style: charStyle));
            charIndex++;
          }
        }

        return Text.rich(
          TextSpan(children: spans),
          textAlign: TextAlign.left,
          softWrap: true,
        );
      },
    );
  }
}
// class TypewriterBlurReveal extends StatelessWidget {
//   final Animation<double> animation;
//   final String text;
//   final TextStyle style;

//   const TypewriterBlurReveal({
//     super.key,
//     required this.animation,
//     required this.text,
//     required this.style,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, _) {
//         // 1. How many characters we want "typed"
//         final int charCount =
//             (text.length * animation.value).ceil().clamp(0, text.length);
//         final String visible = text.substring(0, charCount);
//         final String hidden = text.substring(charCount);

//         // 2. Blur value (from 10 → 0)
//         final double blurValue = (1.0 - animation.value) * 10;

//         // 3. Opacity from 0 → 1
//         final double opacity = animation.value.clamp(0.0, 1.0);

//         return Opacity(
//           opacity: opacity,
//           child: ImageFiltered(
//             imageFilter: ImageFilter.blur(
//               sigmaX: blurValue,
//               sigmaY: blurValue,
//             ),
//             child: Text.rich(
//               TextSpan(
//                 children: [
//                   // Visible typed part
//                   TextSpan(
//                     text: visible,
//                     style: style,
//                   ),
//                   // Invisible but layout-reserving part
//                   TextSpan(
//                     text: hidden,
//                     style: style.copyWith(
//                       color: Colors.transparent,
//                     ),
//                   ),
//                 ],
//               ),
//               // Optional: keep same settings you’d use on Text
//               textAlign: TextAlign.left,
//               softWrap: true,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// -----------------------------------------------------------------------------
// WIDGET 2: Standard Fade + Blur Reveal (For subtext and buttons)
// -----------------------------------------------------------------------------
class FadeBlurReveal extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const FadeBlurReveal({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Blur goes from 10 -> 0
        final double blurValue = (1.0 - animation.value) * 10;

        return Opacity(
          opacity: animation.value,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurValue,
              sigmaY: blurValue,
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
