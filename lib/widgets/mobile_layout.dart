import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/widgets/enter_your_email_textfield.dart';
import 'package:gymm_ai_landing_page/widgets/falling_particles_text.dart';
import 'package:gymm_ai_landing_page/widgets/request_access_button.dart';
import 'package:video_player/video_player.dart';

class MobileLayout extends StatefulWidget {
  final Function(bool) onEmailValidationChanged;
  final TextEditingController emailController;
  final bool isEmailValid;
  final VoidCallback onRequestAccess;

  const MobileLayout({
    super.key,
    required this.onEmailValidationChanged,
    required this.emailController,
    required this.isEmailValid,
    required this.onRequestAccess,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  VideoPlayerController? _mobileVideoController;

  @override
  void initState() {
    super.initState();
    _initializeMobileVideo();
  }

  @override
  void dispose() {
    _mobileVideoController?.dispose();
    super.dispose();
  }

  void _initializeMobileVideo() async {
    _mobileVideoController =
        VideoPlayerController.asset('assets/png/website-video-mobile.mp4');

    try {
      await _mobileVideoController!.setVolume(0);
      await _mobileVideoController!.initialize();
      await _mobileVideoController!.setLooping(true);

      // Add listener for video state changes
      _mobileVideoController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

      // For web, we need to handle autoplay restrictions
      try {
        await _mobileVideoController!.play();
      } catch (playError) {
        print(
            'Mobile video autoplay failed (this is normal on web): $playError');
        // On web, autoplay might fail due to browser restrictions
        // The video will still be ready to play when user interacts
      }

      setState(() {});
    } catch (e) {
      print('Error initializing mobile video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // if (_mobileVideoController != null &&
        //     _mobileVideoController!.value.isInitialized &&
        //     MediaQuery.of(context).size.height > 670)
        Positioned.fill(
          child: FractionallySizedBox(
            heightFactor: MediaQuery.of(context).size.height < 850 ? 0.95 : 1,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: VideoPlayer(_mobileVideoController!),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                SizedBox(
                  height: 30 + 30,
                ),

                // Mobile-optimized main text
                _buildMobileMainText(context),

                const SizedBox(height: 16),

                // Mobile-optimized form section
                _buildMobileFormSection(
                  context,
                  onEmailValidationChanged: widget.onEmailValidationChanged,
                  emailController: widget.emailController,
                  isEmailValid: widget.isEmailValid,
                  onRequestAccess: widget.onRequestAccess,
                ),

                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'Available on Android and iOS',
                    style: TextStyle(
                      color: Color(0xffACACAC).withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (MediaQuery.of(context).viewInsets.bottom > 0)
          SizedBox.shrink()
        else
          Positioned(
            bottom: 22,
            left: 26,
            child: Column(
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
                Text(
                  'Term of Use  ·  Privacy Policy  ·  Contact us',
                  style: TextStyle(
                    color: Color(0xffBBBBBB),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    letterSpacing: 0,
                    height: 20 / 13,
                  ),
                )
              ],
            ),
          )
      ],
    );
  }

  static Widget _buildMobileMainText(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
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
              style: TextStyle(
                fontFamily: 'Suisse',
                fontWeight: FontWeight.w500,
                fontSize: 46.54, // Smaller font size for mobile
                height: 45.25 / 46.54,
                letterSpacing: 0,
                color: Color.fromRGBO(255, 255, 255, 0.9),
              ),
              children: [
                const TextSpan(text: 'Transform your fitness with '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: FallingParticlesText(
                    text: 'AI',
                    textStyle: TextStyle(
                      fontSize: 46.54, // Smaller font size for mobile
                      height: 45.25 / 46.54,
                      letterSpacing: 0,
                      color: const Color.fromRGBO(130, 219, 255, 1),
                      shadows: [
                        const Shadow(
                          color: Color.fromRGBO(63, 89, 255, 1),
                          offset: Offset(0, 0),
                          blurRadius: 9,
                        ),
                        const Shadow(
                          color: Color.fromRGBO(66, 91, 255, 1),
                          offset: Offset(0, 0),
                          blurRadius: 24,
                        ),
                        Shadow(
                          color: const Color.fromRGBO(66, 91, 255, 1),
                          offset: const Offset(0, 32),
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

  static Widget _buildMobileFormSection(
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
            Text(
              'Record. Analyze. Improve.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, // Smaller for mobile
                fontWeight: FontWeight.w500,
                fontFamily: 'Suisse',
                letterSpacing: 0,
              ),
            ),
            Text(
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

        // Email input - full width on mobile
        SizedBox(
          width: double.infinity,
          child: EnterEmail(
            onEmailValidationChanged: onEmailValidationChanged,
            emailController: emailController,
            isMobile: true,
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
      ],
    );
  }
}
