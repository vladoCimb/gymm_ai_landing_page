import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class StoreRedirectPage extends StatefulWidget {
  const StoreRedirectPage({super.key});

  @override
  State<StoreRedirectPage> createState() => _StoreRedirectPageState();
}

class _StoreRedirectPageState extends State<StoreRedirectPage> {
  static const String _appStoreUrl =
      'https://apps.apple.com/us/app/gymm/id6749570108';
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.gymmAI.gymmAI&pcampaignid=web_share';

  String _detectedPlatform = 'Detecting...';
  String? _redirectUrl;

  @override
  void initState() {
    super.initState();
    _detectAndRedirect();
  }

  void _detectAndRedirect() {
    if (!kIsWeb) return;

    final userAgent = html.window.navigator.userAgent.toLowerCase();

    if (_isIOS(userAgent)) {
      _detectedPlatform = 'iOS';
      _redirectUrl = _appStoreUrl;
    } else if (_isAndroid(userAgent)) {
      _detectedPlatform = 'Android';
      _redirectUrl = _playStoreUrl;
    } else {
      // Desktop or unknown — show both options
      _detectedPlatform = 'Desktop';
      _redirectUrl = null;
    }

    if (_redirectUrl != null) {
      // Small delay so the user sees the page briefly, then redirect
      Timer(const Duration(milliseconds: 500), () {
        // Replace current history entry with '/' so if the user comes back
        // to this browser tab, they land on the main landing page
        html.window.history.replaceState(null, '', '/#/');
        html.window.location.href = _redirectUrl!;
      });
    }

    if (mounted) setState(() {});
  }

  bool _isIOS(String ua) {
    return ua.contains('iphone') ||
        ua.contains('ipad') ||
        ua.contains('ipod') ||
        // iPad with desktop mode reports as Macintosh but has touch
        (ua.contains('macintosh') && (html.window.navigator.maxTouchPoints ?? 0) > 0);
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
              // App name / branding
              const Text(
                'Gymm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your AI Fitness Coach',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 48),
              if (_redirectUrl != null) ...[
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Redirecting to $_detectedPlatform store...',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ] else ...[
                // Desktop fallback — show both links
                const Text(
                  'Download Gymm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                _StoreLinkButton(
                  label: 'Download on the App Store',
                  icon: Icons.apple,
                  url: _appStoreUrl,
                ),
                const SizedBox(height: 16),
                _StoreLinkButton(
                  label: 'Get it on Google Play',
                  icon: Icons.shop,
                  url: _playStoreUrl,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreLinkButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;

  const _StoreLinkButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        icon: Icon(icon, size: 28),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
