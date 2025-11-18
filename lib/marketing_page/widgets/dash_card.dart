import 'package:flutter/material.dart';

class DashCard extends StatelessWidget {
  const DashCard(
      {super.key,
      required this.height,
      required this.width,
      required this.child,
      required this.backgroundColor});

  final double height;
  final double width;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}
