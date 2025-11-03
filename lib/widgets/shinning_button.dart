import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShinningButton extends StatefulWidget {
  const ShinningButton(
      {super.key, this.onPressed, this.isMobile = false, required this.text});

  final VoidCallback? onPressed;
  final bool isMobile;
  final String text;

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
              begin: const Color.fromRGBO(175, 178, 255, 1),
              end: (_isHovered || _isFocused)
                  ? const Color.fromRGBO(230, 231, 255, 1)
                  : const Color.fromRGBO(175, 178, 255, 1),
            ),
            builder: (context, firstColor, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(61),
                  gradient: RadialGradient(
                    center: Alignment(
                      (45.77 * 2 / 100) - 1, // Convert % to Alignment X
                      (83 * 2 / 100) - 1, // Convert % to Alignment Y
                    ),
                    radius: 0.65, // 65%
                    colors: [
                      firstColor ?? const Color.fromRGBO(175, 178, 255, 1),
                      const Color.fromRGBO(187, 205, 242, 1),
                    ],
                    stops: const [0.0, 0.9856], // 0% and 98.56%
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 0.25),
                      offset: Offset(0, 4),
                      blurRadius: 20,
                      spreadRadius: 0,
                      inset: false,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(63, 89, 255, 1),
                      offset: Offset(0, 0),
                      blurRadius: 15.96,
                      spreadRadius: 0,
                      inset: false,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(66, 91, 255, 1),
                      offset: Offset(0, 0),
                      blurRadius: 38.77,
                      spreadRadius: 0,
                      inset: false,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      offset: Offset(0, -1),
                      blurRadius: 4,
                      spreadRadius: 0,
                      inset: true,
                    ),
                  ],
                ),
                child: widget.isMobile
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 15.h,
                            bottom: 15.h,
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
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsetsGeometry.only(
                          left: 23.w,
                          right: 20.w,
                          top: 15.h,
                          bottom: 15.h,
                        ),
                        child: Text(
                          widget.text,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            height: 20 / 15,
                            letterSpacing: 0,
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
