import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/marketing_page/new_marketing_page.dart';

class RoadmapPage extends StatelessWidget {
  const RoadmapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: BlurHeaderDelegate(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: isMobile(context) ? 30 : 80),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Title
                MarketingPagePaddingWiget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SelectableText(
                      'Roadmap',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile(context) ? 36 : 72,
                        height: isMobile(context) ? 41 / 36 : 69.8 / 72,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Suisse',
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),

                SizedBox(height: 12),
                // Subtitle
                MarketingPagePaddingWiget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 379,
                      ),
                      child: SelectableText(
                        "Sneak peek of what we're working on and planning to release soon.",
                        style: GoogleFonts.inter(
                          color: Color.fromRGBO(165, 165, 165, 1),
                          fontSize: 18,
                          height: 24 / 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isMobile(context) ? 40 : 80),

                // Feature sections
                MarketingPagePaddingWiget(
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isMobile(context) ? double.infinity : 800,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _RoadmapFeature(
                            title: 'Analytics',
                            description:
                                "We're working on adding an analytics feature to your profile so you can see your overall progress over time for any exercise.",
                            imagePath: 'assets/png/analytics.png',
                          ),
                          SizedBox(height: isMobile(context) ? 40 : 60),
                          _RoadmapFeature(
                            title: 'Chat with AI coach',
                            description:
                                "When you get feedback, you will be able to continue chatting with our AI coach, asking questions or requesting specific information, and getting even better, more tailored feedback just for you.",
                            imagePath: 'assets/png/chat.png',
                          ),
                          SizedBox(height: isMobile(context) ? 40 : 60),
                          _RoadmapFeature(
                            title: 'Live AI voice coach',
                            description:
                                "Wouldn't it be cool if our AI trainer could give you real-time feedback as a voice in your headphones? Yes, we're working on this feature as well.",
                            imagePath: 'assets/png/live_chat.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const NewMarketingFooterWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadmapFeature extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const _RoadmapFeature({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 506,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          SelectableText(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              height: 24 / 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          // Description
          SelectableText(
            description,
            style: GoogleFonts.inter(
              color: Color.fromRGBO(165, 165, 165, 1),
              fontSize: 14,
              height: 19 / 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: isMobile(context) ? 20 : 24),
          // Image
          Center(
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
