import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymm_ai_landing_page/main.dart';

class BlackShinningButton extends StatefulWidget {
  const BlackShinningButton({
    super.key,
    this.onPressed,
    this.isMobile = false,
    required this.text,
    required this.iconUrl,
  });

  final VoidCallback? onPressed;
  final bool isMobile;
  final String text;
  final String iconUrl;

  @override
  State<BlackShinningButton> createState() => _BlackShinningButtonState();
}

class _BlackShinningButtonState extends State<BlackShinningButton> {
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
              begin: const Color.fromRGBO(167, 186, 224, 0.12),
              end: (_isHovered || _isFocused)
                  ? const Color.fromRGBO(167, 186, 224, 0.2)
                  : const Color.fromRGBO(167, 186, 224, 0.12),
            ),
            builder: (context, firstColor, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(61),
                  color: firstColor,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 0.06),
                      offset: Offset(0, 0),
                      blurRadius: 19,
                      spreadRadius: 0,
                      inset: true,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 0.08),
                      offset: Offset(0, 1),
                      blurRadius: 0,
                      spreadRadius: 0,
                      inset: true,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 0.06),
                      offset: Offset(0, 0),
                      blurRadius: 0,
                      spreadRadius: 1,
                      inset: true,
                    ),
                  ],
                ),
                child: widget.isMobile
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 15,
                            bottom: 15,
                          ),
                          child: Text(
                            widget.text,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 20 / 15,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsetsGeometry.only(
                          left: 20,
                          right: 20,
                          top: isMobile(context) ? 13 : 17,
                          bottom: isMobile(context) ? 13 : 17,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              widget.iconUrl,
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              widget.text,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 20 / 15,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
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
