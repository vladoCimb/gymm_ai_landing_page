import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gymm_ai_landing_page/pages/legal_doc_page.dart';
import 'package:gymm_ai_landing_page/services/firebase_service.dart';
import 'package:gymm_ai_landing_page/widgets/elipses.dart';
import 'package:gymm_ai_landing_page/widgets/enter_your_email_textfield.dart';
import 'package:gymm_ai_landing_page/widgets/falling_particles_text.dart';
import 'package:gymm_ai_landing_page/widgets/request_access_button.dart';
import 'package:gymm_ai_landing_page/widgets/mobile_layout.dart';
import 'package:gymm_ai_landing_page/widgets/measure_size.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

// Enum for device types
enum DeviceType {
  desktop,
  tablet,
  mobile,
}

// Function to determine current device type based on screen width
DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1100) {
    return DeviceType.desktop;
  } else if (width >= 768) {
    return DeviceType.tablet;
  } else {
    return DeviceType.mobile;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyCGSSirJE0JPlpRY_ouuQpS1IsPCUHj6lU',
        appId: '1:125731520630:web:71b85271c5bbed81869f57',
        messagingSenderId: '125731520630',
        projectId: 'gymm-6bfe7',
        measurementId: "G-YJMG7TKMVX",
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        if (Firebase.apps.isNotEmpty)
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/privacy_policy': (context) => const PrivacyPolicyPage(),
        '/terms_of_use': (context) => const TermsOfUsePage(),
      },
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  bool _isEmailValid = false;
  bool _wasEmailSubmitted = false;
  final TextEditingController _emailController = TextEditingController();
  VideoPlayerController? _videoController;
  double _buttonWidth = 150; // Default width, will be updated when measured
  final FocusNode _emailFocusNode = FocusNode();
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideo();

    // Check for initial route from web URL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialRoute();
    });
  }

  void _checkInitialRoute() {
    if (!kIsWeb) return;

    try {
      // Get the initial route from JavaScript
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _emailController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App became visible again, reinitialize video if needed
      _handleVideoResume();
    }
  }

  void _handleVideoResume() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      _initializeVideo();
    } else if (_videoController!.value.isPlaying == false) {
      // Try to resume playing if video was paused
      try {
        _videoController!.play();
      } catch (e) {
        print('Error resuming video: $e');
      }
    }
  }

  void _initializeVideo() async {
    if (_videoController != null) {
      await _videoController!.dispose();
    }

    _videoController = VideoPlayerController.asset('assets/png/video.mp4');
    try {
      await _videoController!.setVolume(0);
      await _videoController!.initialize();
      await _videoController!.setLooping(true);

      // Add listener for video state changes
      _videoController!.addListener(() {
        if (mounted) {
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
    }
  }

  void _onEmailValidationChanged(bool isValid) {
    setState(() {
      _isEmailValid = isValid;
    });
  }

  void _onRequestAccess() {
    if (_isEmailValid) {
      final email = _emailController.text.trim();
      FirebaseService.saveBetaEmail(email);
      setState(() {
        _wasEmailSubmitted = true;
      });
      // Clear the text field after submission
      _emailController.clear();
      // TODO: Handle the email submission
      print('Requesting access for: $email');
    }
  }

  Future<void> _openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'v.cimbora123@gmail.com',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Fallback for web or if email app can't be opened
      final webEmailUri = Uri.parse('mailto:v.cimbora123@gmail.com');
      if (await canLaunchUrl(webEmailUri)) {
        await launchUrl(webEmailUri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if video needs to be reinitialized after resize
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          !isMobile(context) &&
          (_videoController == null ||
              !_videoController!.value.isInitialized)) {
        _handleVideoResume();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            if (!isMobile(context))
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.5,
                child: SizedBox(
                  child: FractionallySizedBox(
                    heightFactor: 2,
                    child: RepaintBoundary(child: _buildVideoPlayer(context)),
                  ),
                ),
              ),
            if (isMobile(context))
              Positioned.fill(
                child: MobileLayout(
                  onEmailValidationChanged: _onEmailValidationChanged,
                  emailController: _emailController,
                  isEmailValid: _isEmailValid,
                  onRequestAccess: _onRequestAccess,
                  wasEmailSubmitted: _wasEmailSubmitted,
                ),
              )
            else ...[
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    _buildHeader(context),

                    // Main Content
                    _buildMainContent(context),
                  ],
                ),
              ),
            ],
            if (!isMobile(context))
              Positioned(
                left: 0,
                top: 0,
                child: IgnorePointer(
                  child: Transform.scale(
                    scale: switch (getDeviceType(context)) {
                      DeviceType.desktop => 1.0,
                      DeviceType.tablet => 1.0,
                      DeviceType.mobile => 0.4,
                    },
                    alignment: Alignment.topLeft,
                    child: Elipses(
                      width: 3612,
                      height: 2500,
                    ),
                  ),
                ),
              ),
            if (!isMobile(context))
              Positioned(
                left: 28,
                top: 22,
                child: Image.asset(
                  'assets/png/logo.png',
                  width: !isMobile(context) ? 123 : 93,
                  height: !isMobile(context) ? 31 : 30,
                ),
              ),
            if (!isMobile(context))
              Positioned(
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '© Gymm AI 2025',
                      style: TextStyle(
                        color: Color(0xff848484),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        letterSpacing: 0,
                        height: 20 / 13,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/terms_of_use');
                            },
                            child: Text(
                              'Terms of Use',
                              style: TextStyle(
                                color: Color(0xffBBBBBB),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                letterSpacing: 0,
                                height: 20 / 13,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '  ·  ',
                          style: TextStyle(
                            color: Color(0xffBBBBBB),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            letterSpacing: 0,
                            height: 20 / 13,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/privacy_policy');
                            },
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: Color(0xffBBBBBB),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                letterSpacing: 0,
                                height: 20 / 13,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '  ·  ',
                          style: TextStyle(
                            color: Color(0xffBBBBBB),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            letterSpacing: 0,
                            height: 20 / 13,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: _openEmail,
                            child: Text(
                              'Contact us',
                              style: TextStyle(
                                color: Color(0xffBBBBBB),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                letterSpacing: 0,
                                height: 20 / 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          SizedBox(),

          // Contact button
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        minHeight: screenHeight - 100, // Account for header
      ),
      child: Column(
        children: [
          if (isMobile(context)) ...[
            MobileLayout(
              onEmailValidationChanged: _onEmailValidationChanged,
              emailController: _emailController,
              isEmailValid: _isEmailValid,
              onRequestAccess: _onRequestAccess,
              wasEmailSubmitted: _wasEmailSubmitted,
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(top: 126, left: 40, right: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 1280,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side - Main text
                    _buildMainText(context),

                    _buildFormSection(
                      context,
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildMainText(
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive font size based on screen width
    // Start shrinking when width goes below 1280px
    double baseFontSize = 82.09;
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
                height: 79.81 / 82.09,
                letterSpacing: 0,
                color: Color.fromRGBO(255, 255, 255, 0.9),
              ),
              children: [
                const TextSpan(
                  text: 'Transform your fitness with ',
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: FallingParticlesText(
                    text: 'AI',
                    textStyle: TextStyle(
                      fontSize: 82.09,
                      height: 79.81 / 82.09,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Suisse',
                      letterSpacing: 0,
                      color: const Color.fromRGBO(130, 219, 255, 1),
                      shadows: [
                        const Shadow(
                          color: Color.fromRGBO(63, 89, 255, 1),
                          offset: Offset(0, 0),
                          blurRadius: 10.98,
                        ),
                        const Shadow(
                          color: Color.fromRGBO(66, 91, 255, 1),
                          offset: Offset(0, 0),
                          blurRadius: 36.67,
                        ),
                        Shadow(
                          color: const Color.fromRGBO(66, 91, 255, 1)
                              .withOpacity(0.7),
                          offset: const Offset(0, 20.22),
                          blurRadius: 100.04,
                        ),
                      ],
                    ),
                    particleCount: 15,
                    dropHeight: 80,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  Widget _buildVideoPlayer(
    BuildContext context,
  ) {
    // If video controller is not initialized, try to initialize it
    if (_videoController == null || !_videoController!.value.isInitialized) {
      // Trigger video initialization if not already done
      if (!_isVideoInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              (_videoController == null ||
                  !_videoController!.value.isInitialized)) {
            _initializeVideo();
          }
        });
      }
      return SizedBox();
    }

    // Ensure video is playing if it's initialized but not playing
    if (_videoController!.value.isInitialized &&
        !_videoController!.value.isPlaying) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: VideoPlayer(_videoController!),
    );
  }

  Widget _buildFormSection(
    BuildContext context,
  ) {
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: isDesktop(context)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Feature tags
          SelectionArea(
            child: SizedBox(
              width: 271 + 16 + _buttonWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Record. Analyze. Improve.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Suisse',
                      letterSpacing: 0,
                      height: 26 / 15,
                    ),
                  ),
                  Text(
                    'Our AI-powered trainer turns your phone\ninto a performance-boosting machine.',
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
          ),

          SizedBox(
            height: 31,
          ),
          _wasEmailSubmitted
              ? SelectionArea(
                  child: Container(
                    key: ValueKey('success'),
                    width: 271 + 16 + _buttonWidth,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Thank you!',
                          style: TextStyle(
                            color: Color(0xffACACAC),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            letterSpacing: 0,
                            height: 26 / 16,
                          ),
                        ),
                        Text(
                          'We will let you know once the app is ready.',
                          style: TextStyle(
                            color: Color(0xff616161),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            letterSpacing: 0,
                            height: 26 / 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  key: ValueKey('form'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EnterEmail(
                            onEmailValidationChanged: _onEmailValidationChanged,
                            emailController: _emailController,
                            focusNode: _emailFocusNode,
                          ),
                          SizedBox(width: 16),
                          MeasureSize(
                            onChange: (Size size) {
                              setState(() {
                                _buttonWidth = size.width;
                              });
                            },
                            child: RequestAccessButton(
                              opacity: _isEmailValid ? 1.0 : 0.5,
                              onPressed:
                                  _isEmailValid ? _onRequestAccess : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SelectableText(
                          'Available on Android and iOS',
                          style: TextStyle(
                            color: Color.fromRGBO(172, 172, 172, 0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            letterSpacing: 0,
                            height: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     EnterEmail(
          //       onEmailValidationChanged: _onEmailValidationChanged,
          //       emailController: _emailController,
          //     ),
          //     SizedBox(width: 16),
          //     RequestAccessButton(
          //       opacity: _isEmailValid ? 1.0 : 0.5,
          //       onPressed: _isEmailValid ? _onRequestAccess : null,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}

double height(BuildContext context) => MediaQuery.of(context).size.height;
double width(BuildContext context) => MediaQuery.of(context).size.width;
