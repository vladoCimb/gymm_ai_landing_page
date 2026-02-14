import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gymm_ai_landing_page/constants/app_store_urls.dart';
import 'package:gymm_ai_landing_page/widgets/shinning_button.dart';
import 'package:gymm_ai_landing_page/widgets/black_shinning_button.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class StoreRedirectPage extends StatefulWidget {
  const StoreRedirectPage({super.key});

  @override
  State<StoreRedirectPage> createState() => _StoreRedirectPageState();
}

class _StoreRedirectPageState extends State<StoreRedirectPage> {
  String _detectedPlatform = 'Detecting...';
  String? _redirectUrl;
  bool _didRedirect = false;

  // Event listener references for cleanup
  void Function(html.Event)? _visibilityListener;
  void Function(html.Event)? _pageShowListener;

  @override
  void initState() {
    super.initState();
    _detectAndRedirect();
  }

  @override
  void dispose() {
    // Clean up event listeners
    if (_visibilityListener != null) {
      html.document
          .removeEventListener('visibilitychange', _visibilityListener);
    }
    if (_pageShowListener != null) {
      html.window.removeEventListener('pageshow', _pageShowListener);
    }
    super.dispose();
  }

  void _navigateToLanding() {
    if (mounted) {
      GoRouter.of(context).go('/');
    }
  }

  void _detectAndRedirect() {
    if (!kIsWeb) return;

    final userAgent = html.window.navigator.userAgent.toLowerCase();

    if (_isIOS(userAgent)) {
      _detectedPlatform = 'iOS';
      _redirectUrl = kAppStoreUrl;
    } else if (_isAndroid(userAgent)) {
      _detectedPlatform = 'Android';
      _redirectUrl = kPlayStoreUrl;
    } else {
      // Desktop or unknown — show both options
      _detectedPlatform = 'Desktop';
      _redirectUrl = null;
    }

    if (_redirectUrl != null) {
      // Small delay so the user sees the page briefly, then redirect
      Timer(const Duration(milliseconds: 500), () {
        // Replace current history entry with '/' so if the browser does a
        // full reload (not bfcache), the user lands on the main landing page
        html.window.history.replaceState(null, '', '/');

        // Set up listeners BEFORE redirecting so that when the user comes
        // back to this tab (bfcache restore or tab switch), GoRouter
        // navigates them to the landing page.
        _didRedirect = true;
        _setupReturnListeners();

        // Redirect to the store
        html.window.location.href = _redirectUrl!;
      });
    }

    if (mounted) setState(() {});
  }

  /// Listen for the user returning to this browser tab after the store redirect.
  /// - `pageshow` fires when the page is restored from bfcache (back/forward).
  /// - `visibilitychange` fires when the tab becomes visible again.
  void _setupReturnListeners() {
    _pageShowListener = (html.Event event) {
      if (_didRedirect) {
        _navigateToLanding();
      }
    };
    html.window.addEventListener('pageshow', _pageShowListener);

    _visibilityListener = (html.Event event) {
      if (_didRedirect && html.document.visibilityState == 'visible') {
        _navigateToLanding();
      }
    };
    html.document.addEventListener('visibilitychange', _visibilityListener);
  }

  bool _isIOS(String ua) {
    return ua.contains('iphone') ||
        ua.contains('ipad') ||
        ua.contains('ipod') ||
        // iPad with desktop mode reports as Macintosh but has touch
        (ua.contains('macintosh') &&
            (html.window.navigator.maxTouchPoints ?? 0) > 0);
  }

  bool _isAndroid(String ua) {
    return ua.contains('android');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/png/logo_new.png',
                width: 120,
                height: 38,
              ),
              const SizedBox(height: 20),
              // Subtitle
              Text(
                'Your camera based AI Fitness Coach',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xff7A7A7A),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  height: 24.0 / 18.0,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 48),
              if (_redirectUrl != null) ...[
                Text(
                  'Redirecting to $_detectedPlatform store...',
                  style: GoogleFonts.inter(
                    color: const Color(0xff7A7A7A),
                    fontSize: 18,
                    height: 24.0 / 18.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ] else ...[
                // Desktop fallback — show both links

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShinningButton(
                      onPressed: () {
                        launchUrl(Uri.parse(kAppStoreUrl));
                      },
                      text: 'Download for iPhone',
                      iconUrl: 'assets/png/apple.svg',
                    ),
                    const SizedBox(width: 18),
                    BlackShinningButton(
                      onPressed: () {
                        launchUrl(Uri.parse(kPlayStoreUrl));
                      },
                      text: 'Get it for Android',
                      iconUrl: 'assets/png/android.png',
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
