import 'dart:math' as math;

import 'package:flutter/material.dart' hide BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart'
    hide BoxDecoration;
import 'package:gymm_ai_landing_page/widgets/gradient_box_border.dart';

class EnterEmail extends StatefulWidget {
  final TextEditingController emailController;
  final Function(bool isValid) onEmailValidationChanged;
  final bool isMobile;

  const EnterEmail({
    super.key,
    required this.emailController,
    required this.onEmailValidationChanged,
    this.isMobile = false,
  });

  @override
  State<EnterEmail> createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  bool _isValidEmail = false;
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    final email = widget.emailController.text.trim();
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final isValid = emailRegex.hasMatch(email);

    if (isValid != _isValidEmail) {
      setState(() {
        _isValidEmail = isValid;
      });
      widget.onEmailValidationChanged(isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(61),
                gradient: LinearGradient(
                  transform: GradientRotation(246.75 * math.pi / 90),
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  // begin: _beginFromCssAngle(246.75),
                  // end: _endFromCssAngle(246.75),
                  colors: const [
                    Color.fromRGBO(0, 0, 0, 0.0),
                    Color.fromRGBO(67, 86, 255, 0.4),
                  ],
                  stops: const [0.3498, 0.9627], // 34.98%, 96.27%
                ),
              ),
            ),
          ),
        ),
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Focus(
            onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
            child: TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 200),
              tween: ColorTween(
                begin: const Color.fromRGBO(221, 229, 255, 0.12),
                end: (_isHovered || _isFocused)
                    ? const Color.fromRGBO(221, 229, 255, 0.15)
                    : const Color.fromRGBO(221, 229, 255, 0.12),
              ),
              builder: (context, color, child) {
                return Container(
                  width: widget.isMobile ? double.infinity : 271,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(61),
                    color: color ?? const Color.fromRGBO(221, 229, 255, 0.12),
                    border: GradientBoxBorder(
                      width: 1,
                      gradient: LinearGradient(
                        // CSS 322.08deg → Flutter rotation
                        transform:
                            GradientRotation((25 - 322.08) * math.pi / 180),
                        colors: const [
                          Color.fromRGBO(255, 255, 255, 0.28),
                          Color.fromRGBO(124, 124, 124, 0.1092),
                          Color.fromRGBO(255, 255, 255, 0.21),
                        ],
                        stops: const [
                          0.012,
                          0.5078,
                          0.9555
                        ], // 1.2%, 40.78%, 95.55%
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        offset: Offset(0, 3),
                        blurRadius: 9,
                        spreadRadius: 0,
                        inset: false,
                      ),
                      // BoxShadow(
                      //   color: Color.fromRGBO(255, 255, 255, 0.04),
                      //   offset: Offset(0, 4),
                      //   blurRadius: 6.1,
                      //   spreadRadius: 0,
                      //   inset: true, // this is your inset shadow
                      // ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: 17,
                      right: 17,
                      top: 15,
                      bottom: 15,
                    ),
                    child: TextField(
                      controller: widget.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.email],
                      cursorColor: Colors.white70,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                        height: 20 / 15,
                        letterSpacing: 0,
                      ),
                      decoration: InputDecoration(
                        isCollapsed:
                            true, // we control vertical size via Container
                        border: InputBorder.none,
                        hintText: 'Your email',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                          height: 20 / 15,
                          letterSpacing: 0,
                        ),
                        contentPadding:
                            EdgeInsets.zero, // use our outer padding
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
