import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:gymm_ai_landing_page/widgets/text_button.dart';
import 'package:lottie/lottie.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key, required this.onDownloadPressed});

  final VoidCallback onDownloadPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _LogoButton(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HoverableTextButton(
              onPressed: () {
                context.push('/roadmap');
              },
              text: 'Roadmap',
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.78),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                height: 29 / 14,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            _DownloadButton(
              onPressed: () {
                onDownloadPressed.call();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _LogoButton extends StatefulWidget {
  const _LogoButton();

  @override
  State<_LogoButton> createState() => _LogoButtonState();
}

class _LogoButtonState extends State<_LogoButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/');
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() {
          _isHovered = true;
          _lottieController.forward();
        }),
        onExit: (_) => setState(() {
          _isHovered = false;
          _lottieController.reset();
        }),
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: 100,
            height: 35,
            child: Lottie.asset(
              'assets/png/logo_lottie.json',
              controller: _lottieController,
              repeat: false,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class _DownloadButton extends StatefulWidget {
  const _DownloadButton({
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(61),
        onTap: widget.onPressed,
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Focus(
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          child: TweenAnimationBuilder<Color?>(
            duration: const Duration(milliseconds: 200),
            tween: ColorTween(
              begin: const Color.fromRGBO(244, 245, 249, 0.1),
              end: (_isHovered || _isFocused)
                  ? const Color.fromRGBO(244, 245, 249, 0.13)
                  : const Color.fromRGBO(244, 245, 249, 0.1),
            ),
            builder: (context, backgroundColor, child) {
              final borderColor = (_isHovered || _isFocused)
                  ? const Color.fromRGBO(255, 255, 255, 0.12)
                  : const Color.fromRGBO(255, 255, 255, 0.06);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(61),
                  color: backgroundColor,
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text(
                    'Download',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      height: 20 / 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
