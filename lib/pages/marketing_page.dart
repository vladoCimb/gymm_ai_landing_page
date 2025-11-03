import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/pages/legal_doc_page.dart';
import 'package:gymm_ai_landing_page/services/firebase_service.dart';
import 'package:gymm_ai_landing_page/widgets/elipses.dart';
import 'package:gymm_ai_landing_page/widgets/enter_your_email_textfield.dart';
import 'package:gymm_ai_landing_page/widgets/falling_particles_text.dart';
import 'package:gymm_ai_landing_page/widgets/request_access_button.dart';
import 'package:gymm_ai_landing_page/widgets/mobile_layout.dart';
import 'package:gymm_ai_landing_page/widgets/measure_size.dart';
import 'package:gymm_ai_landing_page/widgets/shinning_button.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;
import 'dart:html' as html;

class MarketingPage extends StatefulWidget {
  const MarketingPage({super.key});

  @override
  State<MarketingPage> createState() => _MarketingPageState();
}

class _MarketingPageState extends State<MarketingPage> {
  VideoPlayerController? _videoController;
  VideoPlayerController? _AIAnimationController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeAIAnimation();
    // Check for initial route from web URL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1)
                  .copyWith(top: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/png/logo.png',
                    width: !isMobile(context) ? 123 : 93,
                    height: !isMobile(context) ? 31 : 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Roadmap',
                        style: TextStyle(
                          color: Colors.white,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainText(context),
                    RepaintBoundary(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Feature tags
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 379),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SelectableText.rich(
                                  textAlign: TextAlign.start,
                                  const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Record. Analyze. Improve. ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Suisse',
                                          letterSpacing: 0,
                                          height: 26 / 15,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Record your training session and receive detailed improvement suggestions.',
                                        style: TextStyle(
                                          color: Color(0xff7A7A7A),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Suisse',
                                          letterSpacing: 0,
                                          height: 26 / 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 33,
                          ),
                          // ShinningButton(
                          //   onPressed: () {},
                          //   text: 'Download',
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  child: RepaintBoundary(child: _buildVideoPlayer(context)),
                )
              ],
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: 634,
                minWidth: MediaQuery.of(context).size.width * 0.3,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                    RichText(
                      textAlign: TextAlign.start,
                      text: const TextSpan(
                        style: TextStyle(
                            fontFamily: 'Suisse',
                            fontWeight: FontWeight.w500,
                            fontSize: 31.03,
                            height: 41.39 / 31.03,
                            letterSpacing: 0,
                            color: Colors.white),
                        children: [
                          TextSpan(
                            text:
                                'Gymm reviews your workout video, spots what a mirror or tracker can’t, and gives you one clear cue to fix on the next rep.\n',
                          ),
                          TextSpan(
                            text:
                                'Mistakes aren’t failures, they’re information. Small adjustments, repeated, become real progress.',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 150,
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: 500,
              ),
              child: Text(
                'Your fitness trainer in the pocket',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Suisse',
                  fontWeight: FontWeight.w500,
                  fontSize: 52.03,
                  height: 54.39 / 52.03,
                  letterSpacing: 0,
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            DashboardSection(
              aIAnimationController: _AIAnimationController,
            ),
            SizedBox(
              height: 100,
            ),
            Stack(
              children: [
                Image.asset(
                  'assets/png/bottom_image.png',
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(
    BuildContext context,
  ) {
    // If video controller is not initialized, return empty container
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return SizedBox();
    }

    // Check if video is playing, if not, try to play it
    if (_videoController!.value.isInitialized &&
        !_videoController!.value.isPlaying) {
      // Use a microtask to avoid calling setState during build
      Future.microtask(() {
        if (mounted &&
            _videoController != null &&
            _videoController!.value.isInitialized) {
          try {
            _videoController!.play();
          } catch (e) {
            print('Error auto-playing video: $e');
          }
        }
      });
    }

    // Constrain size to avoid unbounded layout in Row
    final aspectRatio = _videoController!.value.aspectRatio;
    final targetHeight = MediaQuery.of(context).size.height;
    final targetWidth = targetHeight * aspectRatio;

    return SizedBox(
      width: targetWidth,
      height: targetHeight,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: VideoPlayer(_videoController!),
      ),
    );
  }

  Widget _buildMainText(
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive font size based on screen width
    // Start shrinking when width goes below 1280px
    double baseFontSize = 72.0;
    double responsiveFontSize = baseFontSize;

    if (screenWidth < 1100) {
      // Calculate scale factor: at 1100px = 1.0, at 950px = 0.6 (more aggressive scaling)
      double scaleFactor = 0.6 + (0.4 * (screenWidth - 950) / (1100 - 950));
      scaleFactor = scaleFactor.clamp(0.6, 1.0); // Clamp between 0.6 and 1.0
      responsiveFontSize = baseFontSize * scaleFactor;
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth > 950 ? 470 : 250,
        minWidth: screenWidth > 950 ? 470 : 150,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main headline
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Suisse',
                fontWeight: FontWeight.w500,
                fontSize: responsiveFontSize,
                height: 69.8 / 72.0,
                letterSpacing: 0,
                color: Colors.white,
              ),
              children: [
                const TextSpan(
                  text: 'Your personal AI fitness coach',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _initializeAIAnimation() async {
    // Don't reinitialize if already initialized
    if (_AIAnimationController != null &&
        _AIAnimationController!.value.isInitialized) {
      return;
    }

    // Dispose existing controller if it exists
    if (_AIAnimationController != null) {
      try {
        await _AIAnimationController!.dispose();
      } catch (e) {
        print('Error disposing AI animation controller: $e');
      }
      _AIAnimationController = null;
    }

    try {
      _AIAnimationController =
          VideoPlayerController.asset('assets/png/ai_animation.mp4');
      await _AIAnimationController!.setVolume(0);
      await _AIAnimationController!.initialize();
      await _AIAnimationController!.setLooping(true);

      // Add listener for video state changes
      _AIAnimationController!.addListener(() {
        if (mounted && _AIAnimationController != null) {
          setState(() {});
        }
      }); // For web, we need to handle autoplay restrictions
      try {
        await _AIAnimationController!.play();
        _isVideoInitialized = true;
      } catch (playError) {
        print('Autoplay failed (this is normal on web): $playError');
        // On web, autoplay might fail due to browser restrictions
        // The video will still be ready to play when user interacts
        _isVideoInitialized = true;
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing AI animation: $e');
      _AIAnimationController = null;
    }
  }

  void _initializeVideo() async {
    // Don't reinitialize if already initialized
    if (_videoController != null && _videoController!.value.isInitialized) {
      return;
    }

    // Dispose existing controller if it exists
    if (_videoController != null) {
      try {
        await _videoController!.dispose();
      } catch (e) {
        print('Error disposing video controller: $e');
      }
      _videoController = null;
    }

    try {
      _videoController =
          VideoPlayerController.asset('assets/png/website-video-mobile.mp4');
      await _videoController!.setVolume(0);
      await _videoController!.initialize();
      await _videoController!.setLooping(true);

      // Add listener for video state changes
      _videoController!.addListener(() {
        if (mounted && _videoController != null) {
          setState(() {});
        }
      });

      // For web, we need to handle autoplay restrictions
      try {
        await _videoController!.play();
        _isVideoInitialized = true;
      } catch (playError) {
        print('Autoplay failed (this is normal on web): $playError');
        // On web, autoplay might fail due to browser restrictions
        // The video will still be ready to play when user interacts
        _isVideoInitialized = true;
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing video: $e');
      _isVideoInitialized = false;
      _videoController = null;
    }
  }

  void _checkInitialRoute() {
    if (!kIsWeb) return;

    try {
      // Check for route in URL query parameters (from 404.html redirect)
      final uri = Uri.parse(html.window.location.href);
      final queryParams = uri.queryParameters;

      if (queryParams.containsKey('/')) {
        final route = queryParams['/']!;
        if (route == 'privacy_policy') {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const PrivacyPolicyPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) => child,
            ),
          );
        } else if (route == 'terms_of_use') {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const TermsOfUsePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) => child,
            ),
          );
        }
        return;
      }

      // Get the initial route from JavaScript (fallback)
      final initialRoute = js.context['initialRoute'];
      if (initialRoute != null && initialRoute.toString() != '/') {
        final route = initialRoute.toString();

        // Clear the stored route
        js.context['initialRoute'] = '/';

        // Navigate to the correct page
        if (route == '/privacy_policy') {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const PrivacyPolicyPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) => child,
            ),
          );
        } else if (route == '/terms_of_use') {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const TermsOfUsePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) => child,
            ),
          );
        }
      }
    } catch (e) {
      print('Error checking initial route: $e');
    }
  }

  bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }
}

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key, required this.aIAnimationController});

  final VideoPlayerController? aIAnimationController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 800;

        if (isNarrow) {
          // MOBILE / TABLET
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DashCard(
                height: 160,
                child: const Text('Top Left'),
              ),
              const SizedBox(height: 16),
              _DashCard(
                height: 160,
                child: const Text('Top Right'),
              ),
              const SizedBox(height: 16),
              _DashCard(
                height: 260,
                child: const Text('Big Middle'),
              ),
              const SizedBox(height: 16),

              // bottom row splits into two then one
              Row(
                children: [
                  Expanded(
                    child: _DashCard(
                      height: 140,
                      child: const Text('Bottom 1'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DashCard(
                      height: 140,
                      child: const Text('Bottom 2'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DashCard(
                      height: 140,
                      child: const Text('Bottom 3'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: SizedBox(), // visual spacer
                  ),
                ],
              ),
            ],
          );
        } else {
          // DESKTOP
          // we center content and clamp width so it doesn't stretch super wide

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // top row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3, // ~2/6
                        child: _DashCard(
                          height: 456,
                          backgroundColor: Color.fromRGBO(10, 15, 36, 0.7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (aIAnimationController != null)
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        Color.fromRGBO(10, 15, 36, 0.7),
                                        BlendMode.modulate,
                                      ),
                                      child:
                                          VideoPlayer(aIAnimationController!),
                                    ),
                                  ),
                                ),
                              RichText(
                                textAlign: TextAlign.start,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Gymm AI reviews your workout video, spots what a mirror or tracker can’t,',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Suisse',
                                        letterSpacing: 0,
                                        height: 26 / 26,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' and gives you one clear cue to fix on the next rep.',
                                      style: TextStyle(
                                        color: Color(0xff7A7A7A),
                                        fontSize: 26,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Suisse',
                                        letterSpacing: 0,
                                        height: 26 / 26,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Flexible(
                        flex: 4, // ~4/6
                        child: _DashCard(
                          backgroundColor: Color.fromRGBO(42, 28, 67, 0.5),
                          height: 456,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Gymm reviews your workout video, spots what a mirror or tracker can’t',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Suisse',
                                    letterSpacing: 0,
                                    height: 26 / 26,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // big middle
                  _DashCard(
                      height: 503,
                      backgroundColor: Color.fromRGBO(38, 41, 62, 1),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Track your workouts and get detailed feedback ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Suisse',
                                      letterSpacing: 0,
                                      height: 26 / 26,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Flexible(
                                  child: Text(
                                    'Gymm reviews your workout video, spots what a mirror or tracker can’t, and gives you one clear cue to fix on the next rep. Gymm reviews your workout video, spots what a mirror or tracker can’t, and gives you one clear cue to fix on the next rep.',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Suisse',
                                      letterSpacing: 0,
                                      height: 24 / 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Container(
                              color: Colors.blue,
                            ),
                          )
                        ],
                      )),
                  const SizedBox(height: 24),

                  // bottom row of 3
                  Row(
                    children: [
                      Expanded(
                        child: _DashCard(
                          height: 263,
                          backgroundColor: Color.fromRGBO(36, 45, 63, 0.5),
                          child: const Text('Bottom 1'),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _DashCard(
                          height: 263,
                          backgroundColor: Color.fromRGBO(37, 35, 50, 0.7),
                          child: const Text('Bottom 2'),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _DashCard(
                          backgroundColor: Color.fromRGBO(29, 43, 45, 0.7),
                          height: 263,
                          child: const Text('Bottom 3'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class _DashCard extends StatelessWidget {
  final double height;
  final Widget child;
  final Color backgroundColor;

  const _DashCard({
    required this.height,
    required this.child,
    this.backgroundColor = const Color.fromRGBO(28, 31, 36, 0.7),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: const Color.fromRGBO(255, 255, 255, 0.06), width: 1),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(36),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'Suisse',
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
        child: child,
      ),
    );
  }
}
