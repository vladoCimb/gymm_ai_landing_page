import 'package:flutter/material.dart';
import 'package:gymm_ai_landing_page/main.dart';
import 'package:gymm_ai_landing_page/marketing_page/new_marketing_page.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LegalDocPage extends StatelessWidget {
  final String title;
  final String body;

  const LegalDocPage({
    super.key,
    required this.title,
    required this.body,
  });

  /// Converts plain text with numbered headings to markdown format
  /// Lines starting with "1. ", "2. ", etc. become markdown headings
  static String _convertToMarkdown(String text) {
    final lines = text.split('\n');
    final markdownLines = <String>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final isLastLine = i == lines.length - 1;
      final nextLine = isLastLine ? null : lines[i + 1];

      // Check if line starts with a number followed by a period and space (e.g., "1. ", "10. ")
      final headingMatch = RegExp(r'^(\d+)\.\s+(.+)$').firstMatch(line);
      if (headingMatch != null) {
        // Convert to markdown heading
        // Add empty line before heading if there's any previous content
        if (i > 0) {
          final prevLine = lines[i - 1];
          // If previous line was not empty, ensure we have a blank line before heading
          if (prevLine.trim().isNotEmpty) {
            // Add empty line if last markdown line is not already empty
            if (markdownLines.isEmpty || markdownLines.last.trim().isNotEmpty) {
              markdownLines.add('');
            }
          }
        }
        markdownLines
            .add('# ${headingMatch.group(1)}. ${headingMatch.group(2)}');
      } else if (line.trim().isEmpty) {
        // Empty line - preserve as paragraph break (double newline)
        markdownLines.add('');
      } else {
        // Regular content line - check what comes next to determine break type
        final isNextLineEmpty = nextLine == null || nextLine.trim().isEmpty;
        final isNextLineHeading = nextLine != null &&
            RegExp(r'^(\d+)\.\s+(.+)$').firstMatch(nextLine) != null;

        // Add line with two spaces at the end for hard line break
        // unless next line is empty (paragraph break) or a heading
        if (!isLastLine && !isNextLineEmpty && !isNextLineHeading) {
          markdownLines.add('$line  '); // Two spaces for hard line break
        } else {
          markdownLines.add(line);
        }
      }
    }

    return markdownLines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    // Convert body text to markdown
    final markdownBody = _convertToMarkdown(body);

    // Create custom markdown style sheet
    final markdownStyleSheet = MarkdownStyleSheet(
      h1: TextStyle(
        color: Colors.white,
        fontSize: 18,
        height: 21 / 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500, // Medium
      ),
      p: TextStyle(
        color: Colors.white,
        fontSize: 14,
        height: 21 / 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w300, // Regular
      ),
      listBullet: TextStyle(
        color: Colors.white,
        fontSize: 14,
        height: 21 / 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w300,
      ),
      a: TextStyle(
        color: Colors.white,
        fontSize: 14,
        height: 21 / 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w300,
      ),
    );

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
                MarketingPagePaddingWiget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile(context) ? 36 : 72,
                        height: isMobile(context) ? 41 / 36 : 69.8 / 72,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Suisse',
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                SizedBox(height: isMobile(context) ? 30 : 60),
                // Use MarkdownBody to render markdown with custom styling
                MarketingPagePaddingWiget(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 642,
                    ),
                    child: SelectionArea(
                      child: MarkdownBody(
                        data: markdownBody,
                        styleSheet: markdownStyleSheet,
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

/// --------------------
/// Concrete pages
/// --------------------

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocPage(
      title: 'Privacy Policy',
      body: _privacyPolicyText,
    );
  }
}

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocPage(
      title: 'Terms of Use',
      body: _termsOfUseText,
    );
  }
}

/// --------------------
/// Document contents
/// (sourced from your uploaded files)
/// --------------------

const String _privacyPolicyText = '''
This Privacy Policy describes how Vladmir Cimbora s.r.o., a company based in the Czech Republic (“we,” “our,” or “us”), collects, uses, and protects the personal information of users (“you” or “your”) when using our AI-powered fitness application (“App”).


1. Information We Collect
We may collect the following information when you use the App:
• Personal Information: such as your name, email address, and account details when you register.
• Video Data: recordings you upload for movement analysis and recommendation purposes.
• Device Information: including IP address, device type, and operating system.
• Usage Data: such as interactions within the App and preferences.

2. How We Use Your Information
We use your information for the following purposes:
• To provide AI-powered fitness recommendations.
• To improve and personalize the App’s performance.
• To communicate with you about updates, support, and customer service.
• To comply with legal obligations.

3. Video Data and AI Training
• Your video recordings are primarily processed to generate personalized recommendations.
• In some cases, we may also use your videos to improve and train our AI models, but only with your explicit consent.
• If you do not consent, your videos will be used strictly for providing recommendations and will not be stored for training purposes.

4. Use of Third-Party Providers
Our recommendations are powered by third-party AI service providers. While we take steps to ensure your data is handled securely, we are not responsible for the actions, recommendations, or services provided by third parties.

5. Health Disclaimer
The App provides fitness-related recommendations generated by AI. These are not medical or professional fitness advice. You should always consult with a licensed fitness trainer or medical professional before acting on any recommendations. We are not liable for any injuries, damages, or health issues that may arise from using the App.

6. Data Retention
• Video recordings may be processed temporarily to generate recommendations.
• If you consent to allow videos for AI training, they may be stored securely for that purpose.
• Personal data is retained only as long as necessary for the purpose it was collected or as required by law.

7. Data Sharing
We do not sell your personal information. We may share limited data with:
• Service providers for AI processing and analytics.
• Legal authorities if required by law.

8. Security
We take reasonable steps to protect your information. However, no method of transmission or storage is 100% secure, and we cannot guarantee absolute security.

9. Your Rights (GDPR Compliance)
As an EU-based company, we comply with the General Data Protection Regulation (GDPR). You have the right to:
• Access, correct, or delete your personal data.
• Request data portability.
• Withdraw consent at any time (especially regarding use of videos for AI training).
• File a complaint with your local Data Protection Authority.

10. Contact Us
If you have questions about this Privacy Policy or your personal data, please contact us at:
Vladmir Cimbora s.r.o.
v.cimbora123@gmail.com


Last updated: 18.8.2025
''';

const String _termsOfUseText = '''
These Terms of Use (“Terms”) govern your use of the AI-powered fitness application (“App”) provided by Vladmir Cimbora s.r.o., a company registered in the Czech Republic. By using the App, you agree to these Terms. If you do not agree, please do not use the App.


1. Eligibility
You must be at least 18 years old or have parental/guardian consent to use the App.

2. Use of the App
• The App is intended for personal fitness guidance and not for medical purposes.
• You may not misuse the App, including attempting to reverse-engineer, hack, or exploit it.
• We reserve the right to modify or discontinue features without prior notice.

3. Video Data and AI Use
• By using the App, you understand that your videos are processed by AI to generate recommendations.
• With your consent, your videos may also be used to train and improve AI models.
• If you do not consent, your videos will be processed only for immediate recommendations and not stored for training.

4. Health Disclaimer
• The App’s recommendations are generated by AI and may not always be accurate or suitable for your specific health condition.
• Always consult with your doctor or fitness professional before following any recommendations.
• By using the App, you acknowledge that we are not liable for injuries, damages, or adverse outcomes resulting from reliance on AI recommendations.

5. Third-Party Providers
Our recommendations are powered by third-party AI services. We do not control and are not responsible for the reliability, accuracy, or consequences of their output.

6. Limitation of Liability
To the maximum extent permitted by law:
• We disclaim all warranties regarding the App, whether express or implied.
• We are not responsible for direct, indirect, incidental, or consequential damages resulting from the use or inability to use the App.

7. Intellectual Property
All content, trademarks, and software associated with the App are the property of Vladmir Cimbora s.r.o. or its licensors. You may not copy, modify, or distribute them without prior written consent.

8. Termination
We may suspend or terminate your access to the App if you violate these Terms or misuse the service.

9. Governing Law
These Terms are governed by the laws of the Czech Republic and applicable EU regulations. Any disputes will be resolved in the competent courts of the Czech Republic.

10. Updates to Terms
We may update these Terms from time to time. Continued use of the App after updates constitutes acceptance of the revised Terms.

11. Contact
For questions regarding these Terms, please contact:
Vladmir Cimbora s.r.o.
v.cimbora123@gmail.com

Last updated: 18.8.2025
''';
