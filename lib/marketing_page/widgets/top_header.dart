import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _LogoButton(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                context.push('/roadmap');
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  'Roadmap',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    letterSpacing: 0,
                    height: 29 / 14,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            _DownloadButton(
              onPressed: () {},
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

class _LogoButtonState extends State<_LogoButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/');
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Image.asset(
            'assets/png/logo_new.png',
            width: 88.24,
            height: 27.09,
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
                  ? const Color.fromRGBO(255, 255, 255, 0.18)
                  : const Color.fromRGBO(255, 255, 255, 0.12);

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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
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
