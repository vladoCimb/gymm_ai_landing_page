import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/marketing_page/new_marketing_page.dart';
import 'package:gymm_ai_landing_page/widgets/shinning_button.dart';

class PressKitPage extends StatelessWidget {
  const PressKitPage({super.key});

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
                    child: Text(
                      'Press kit',
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
                      child: Text(
                        "Here you will find our logo and branding assets you can use.",
                        style: TextStyle(
                          color: Color.fromRGBO(165, 165, 165, 1),
                          fontSize: 20,
                          height: 25 / 20,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Suisse',
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Download button
                MarketingPagePaddingWiget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ShinningButton(
                      onPressed: () {
                        // TODO: Add download press kit functionality
                      },
                      text: 'Download press kit',
                      isMobile: isMobile(context),
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
