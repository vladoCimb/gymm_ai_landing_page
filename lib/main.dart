import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymm_ai_landing_page/marketing_page/new_marketing_page.dart';
import 'package:gymm_ai_landing_page/pages/legal_doc_page.dart';
import 'package:gymm_ai_landing_page/pages/marketing_page1.dart';
import 'package:gymm_ai_landing_page/pages/roadmap_page.dart';
import 'package:gymm_ai_landing_page/pages/press_kit_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Enum for device types
enum DeviceType {
  desktop,
  tablet,
  mobile,
}

// Function to determine current device type based on screen width
DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1200) {
    return DeviceType.desktop;
  } else if (width >= 800) {
    return DeviceType.tablet;
  } else {
    return DeviceType.mobile;
  }
}

bool isMobile(BuildContext context) {
  return getDeviceType(context) == DeviceType.mobile;
}

bool isTablet(BuildContext context) {
  return getDeviceType(context) == DeviceType.tablet;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDr1reBoyNgPkhI_74reNhU9AMrEs8D3wo",
          authDomain: "gymmemails.firebaseapp.com",
          projectId: "gymmemails",
          storageBucket: "gymmemails.firebasestorage.app",
          messagingSenderId: "354600174377",
          appId: "1:354600174377:web:00f4cf7d0808e260c12d38"),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // 1. Define the Router configuration
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    // Add your Firebase Observer here so it tracks page changes automatically
    observers: [
      if (Firebase.apps.isNotEmpty)
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const NewMarketingPage(),
      ),
      GoRoute(
        path: '/marketing_page',
        builder: (context, state) => const NewMarketingPage(),
      ),
      GoRoute(
        path: '/privacy_policy',
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: '/terms_of_use',
        builder: (context, state) => const TermsOfUsePage(),
      ),
      GoRoute(
        path: '/roadmap',
        builder: (context, state) => const RoadmapPage(),
      ),
      GoRoute(
        path: '/press_kit',
        builder: (context, state) => const PressKitPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1440, 1024),
        enableScaleText: () => true,
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router, // Pass the configuration here
          );
        }

        // child: MaterialApp(
        //   debugShowCheckedModeBanner: false,
        //   navigatorObservers: [
        //     if (Firebase.apps.isNotEmpty)
        //       FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        //   ],
        //   initialRoute: '/',
        //   routes: {
        //     '/': (context) => const NewMarketingPage(),
        //     '/privacy_policy': (context) => const PrivacyPolicyPage(),
        //     '/terms_of_use': (context) => const TermsOfUsePage(),
        //     '/marketing_page': (context) => const NewMarketingPage(),
        //   },
        // ),
        );
  }
}

double height(BuildContext context) => MediaQuery.of(context).size.height;
double width(BuildContext context) => MediaQuery.of(context).size.width;
