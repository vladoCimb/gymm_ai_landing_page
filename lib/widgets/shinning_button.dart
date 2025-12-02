import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ShinningButton extends StatefulWidget {
  const ShinningButton({
    super.key,
    this.onPressed,
    this.isMobile = false,
    required this.text,
    this.iconUrl,
  });

  final VoidCallback? onPressed;
  final bool isMobile;
  final String text;
  final String? iconUrl;

  @override
  State<ShinningButton> createState() => _ShinningButtonState();
}

class _ShinningButtonState extends State<ShinningButton> {
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
        child: Focus(
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          child: TweenAnimationBuilder<Color?>(
            duration: const Duration(milliseconds: 200),
            tween: ColorTween(
              begin: Color.fromRGBO(187, 205, 242, 1),
              end: (_isHovered || _isFocused)
                  ? Color.fromRGBO(228, 235, 250, 1)
                  : Color.fromRGBO(187, 205, 242, 1),
              // begin: const Color.fromRGBO(175, 178, 255, 1),
              // end: (_isHovered || _isFocused)
              //     ? const Color.fromRGBO(230, 231, 255, 1)
              //     : const Color.fromRGBO(175, 178, 255, 1),
            ),
            builder: (context, firstColor, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(61),
                  color: firstColor,
                  // gradient: RadialGradient(
                  //   center: Alignment(
                  //     (45.77 * 2 / 100) - 1, // Convert % to Alignment X
                  //     (83 * 2 / 100) - 1, // Convert % to Alignment Y
                  //   ),
                  //   radius: 0.65, // 65%
                  //   colors: [
                  //     firstColor ?? Color.fromRGBO(187, 205, 242, 1),
                  //     const Color.fromRGBO(187, 205, 242, 1),
                  //   ],
                  //   stops: const [0.0, 0.9856], // 0% and 98.56%
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      offset: Offset(0, 0),
                      blurRadius: 19,
                      spreadRadius: 0,
                      inset: true,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      offset: Offset(0, 1),
                      blurRadius: 0,
                      spreadRadius: 0,
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
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                              height: 20 / 15,
                              letterSpacing: 0,
                              shadows: [
                                Shadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.4),
                                  offset: Offset(0, 1),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsetsGeometry.only(
                          left: 16,
                          right: 16,
                          top: 11,
                          bottom: 11,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.iconUrl != null)
                              Stack(
                                children: [
                                  Positioned(
                                    top: 1,
                                    child: SvgPicture.asset(
                                      widget.iconUrl!,
                                      color: Color.fromRGBO(255, 255, 255, 0.4),
                                    ),
                                  ),
                                  SvgPicture.asset(widget.iconUrl!),
                                ],
                              ),
                            if (widget.iconUrl != null)
                              SizedBox(
                                width: 6,
                              ),
                            Text(
                              widget.text,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                height: 20 / 15,
                                letterSpacing: 0,
                                shadows: [
                                  Shadow(
                                    color: Color.fromRGBO(255, 255, 255, 0.4),
                                    offset: Offset(0, 1),
                                    blurRadius: 0,
                                  ),
                                ],
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
