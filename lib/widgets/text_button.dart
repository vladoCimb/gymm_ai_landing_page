import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HoverableTextButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? style;

  const HoverableTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
  });

  @override
  State<HoverableTextButton> createState() => _HoverableTextButtonState();
}

class _HoverableTextButtonState extends State<HoverableTextButton> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Colors.white,
    );

    final textStyle = widget.style ?? defaultStyle;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Focus(
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 200),
              tween: ColorTween(
                begin: textStyle.color,
                end:
                    (_isHovered || _isFocused) ? Colors.white : textStyle.color,
              ),
              builder: (context, color, child) {
                return Text(
                  widget.text,
                  style: textStyle.copyWith(color: color),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
