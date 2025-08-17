import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/widgets/elipses.dart';
import 'package:gymm_ai_landing_page/widgets/enter_your_email_textfield.dart';
import 'package:gymm_ai_landing_page/widgets/falling_particles_text.dart';
import 'package:gymm_ai_landing_page/widgets/request_access_button.dart';
import 'package:video_player/video_player.dart';

class MobileLayout extends StatefulWidget {
  final Function(bool) onEmailValidationChanged;
  final TextEditingController emailController;
  final bool isEmailValid;
  final VoidCallback onRequestAccess;
  final bool wasEmailSubmitted;

  const MobileLayout({
    super.key,
    required this.onEmailValidationChanged,
    required this.emailController,
    required this.isEmailValid,
    required this.onRequestAccess,
    required this.wasEmailSubmitted,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  VideoPlayerController? _mobileVideoController;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  bool _isKeyboardVisible = false;

  // Video dimensions
  static const double videoOriginalWidth = 1420;
  static const double videoOriginalHeight = 3132;
  static const double videoAspectRatio =
      videoOriginalWidth / videoOriginalHeight;

  // Approximate percentage where actual content starts in the video (after black frame)
  static const double blackFramePercentage = 0.6; // Adjust based on your video
  static const double actualVideoContentHeightRatio = 1 - blackFramePercentage;

  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeMobileVideo();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 700), () {
          setState(() {
            _isKeyboardVisible = _emailFocusNode.hasFocus;
          });
        });
      } else {
        setState(() {
          _isKeyboardVisible = _emailFocusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _mobileVideoController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeMobileVideo() async {
    _mobileVideoController =
        VideoPlayerController.asset('assets/png/website-video-mobile.mp4');

    try {
      await _mobileVideoController!.setVolume(0);
      await _mobileVideoController!.initialize();
      await _mobileVideoController!.setLooping(true);

      _mobileVideoController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

      try {
        await _mobileVideoController!.play();
      } catch (playError) {
        print(
            'Mobile video autoplay failed (this is normal on web): $playError');
      }

      setState(() {});
    } catch (e) {
      print('Error initializing mobile video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate video dimensions when scaled to screen width
    final scaledVideoHeight = screenWidth / videoAspectRatio;
    final scaledActualContentHeight =
        scaledVideoHeight * actualVideoContentHeightRatio - 100;

    // Calculate content height (all elements before "Available on Android and iOS")
    const contentHeight = 22 + // top padding
        60 + // Logo space
        200 + // Approximate height for main text
        16 + // spacing
        180 + // Approximate height for form section
        14 + // spacing
        20 + // "Available on Android and iOS" text height
        14; // bottom spacing

    // Calculate required spacing to show at least half of video content
    final availableSpaceBelow = screenHeight - contentHeight; // minus footer

    return Stack(
      children: [
        // Video background - moves with scroll
        if (_mobileVideoController != null &&
            _mobileVideoController!.value.isInitialized)
          Positioned(
            // Position video based on scroll offset
            // Start showing from black frame, then reveal phone content as user scrolls
            top: contentHeight -
                scaledVideoHeight * blackFramePercentage -
                _scrollOffset * 1,
            left: 0,
            width: screenWidth,
            height: scaledVideoHeight,
            child: VideoPlayer(_mobileVideoController!),
          ),
        Positioned(
          left: 0,
          top: 0,
          child: IgnorePointer(
            child: Transform.scale(
              scale: 0.4,
              alignment: Alignment.topLeft,
              child: Elipses(
                width: 3612,
                height: 2500,
              ),
            ),
          ),
        ),

        // Scrollable content
        SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // Main content container
              Container(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo
                          Image.asset(
                            'assets/png/logo.png',
                            width: 93,
                            height: 30,
                          ),
                          SizedBox(
                            height: 29,
                          ),

                          // Mobile-optimized main text
                          _buildMobileMainText(context),

                          const SizedBox(height: 16),

                          // Mobile-optimized form section
                          _buildMobileFormSection(
                            context,
                            onEmailValidationChanged:
                                widget.onEmailValidationChanged,
                            emailController: widget.emailController,
                            isEmailValid: widget.isEmailValid,
                            onRequestAccess: widget.onRequestAccess,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Extra scrollable space to reveal the full video
              SizedBox(
                height: (scaledActualContentHeight > availableSpaceBelow
                        ? scaledActualContentHeight - availableSpaceBelow + 100
                        : 100) -
                    100,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 26, bottom: 22, top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '© Gymm AI 2025',
                        style: TextStyle(
                          color: const Color(0xff848484),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          letterSpacing: 0,
                          height: 20 / 13,
                        ),
                      ),
                      Text(
                        'Term of Use  ·  Privacy Policy  ·  Contact us',
                        style: TextStyle(
                          color: const Color(0xffBBBBBB),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          letterSpacing: 0,
                          height: 20 / 13,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildMobileMainText(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 270,
        minWidth: 200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main headline - smaller for mobile
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Suisse',
                fontWeight: FontWeight.w500,
                fontSize: 46.54, // Smaller font size for mobile
                height: 45.25 / 46.54,
                letterSpacing: 0,
                color: Color.fromRGBO(255, 255, 255, 0.9),
              ),
              children: [
                const TextSpan(
                  text: 'Transform your fitness with ',
                  style: TextStyle(
                    fontFamily: 'Suisse',
                    fontWeight: FontWeight.w500,
                    fontSize: 46.54, // Smaller font size for mobile
                    height: 45.25 / 46.54,
                    letterSpacing: 0,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: FallingParticlesText(
                    text: 'AI',
                    textStyle: const TextStyle(
                      fontSize: 46.54, // Smaller font size for mobile
                      height: 45.25 / 46.54,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(130, 219, 255, 1),
                      shadows: [
                        Shadow(
                          color: Color.fromRGBO(63, 89, 255, 1),
                          offset: Offset(0, 0),
                          blurRadius: 9,
                        ),
                        Shadow(
                          color: Color.fromRGBO(66, 91, 255, 1),
                          offset: Offset(0, 0),
                          blurRadius: 24,
                        ),
                        Shadow(
                          color: Color.fromRGBO(66, 91, 255, 1),
                          offset: Offset(0, 32),
                          blurRadius: 48,
                        ),
                      ],
                    ),
                    particleCount: 10, // Fewer particles for mobile
                    dropHeight: 60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFormSection(
    BuildContext context, {
    required Function(bool) onEmailValidationChanged,
    required TextEditingController emailController,
    required bool isEmailValid,
    required VoidCallback onRequestAccess,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Feature tags - mobile optimized
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record. Analyze. Improve.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, // Smaller for mobile
                fontWeight: FontWeight.w500,
                fontFamily: 'Suisse',
                letterSpacing: 0,
              ),
            ),
            const Text(
              'Our AI-powered trainer turns your phone\ninto a performance-boosting machine.',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(0xff7A7A7A),
                fontSize: 16, // Smaller for mobile
                fontWeight: FontWeight.w500,
                fontFamily: 'Suisse',
                letterSpacing: 0,
                height: 1.4,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        if (widget.wasEmailSubmitted)
          Column(
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
          )
        else ...[
          // Email input - full width on mobile
          SizedBox(
            width: double.infinity,
            child: EnterEmail(
              onEmailValidationChanged: onEmailValidationChanged,
              emailController: emailController,
              isMobile: true,
              focusNode: _emailFocusNode,
              comingFromMobileLayout: true,
            ),
          ),

          const SizedBox(height: 16),

          // Request access button - full width on mobile
          SizedBox(
            width: double.infinity,
            child: RequestAccessButton(
              opacity: isEmailValid ? 1.0 : 0.5,
              onPressed: isEmailValid ? onRequestAccess : null,
              isMobile: true,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
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
            ),
          )
        ]
      ],
    );
  }
}
