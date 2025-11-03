import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymm_ai_landing_page/marketing_page/new_marketing_page.dart';
import 'package:gymm_ai_landing_page/pages/legal_doc_page.dart';
import 'package:gymm_ai_landing_page/pages/marketing_page.dart';
import 'package:gymm_ai_landing_page/pages/marketing_page1.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      enableScaleText: () => true,
      minTextAdapt: true,
      builder: (context, child) => child!,
      child: MaterialApp(
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
          '/marketing_page': (context) => const NewMarketingPage(),
        },
      ),
    );
  }
}

double height(BuildContext context) => MediaQuery.of(context).size.height;
double width(BuildContext context) => MediaQuery.of(context).size.width;
