import 'package:flutter/material.dart';
import 'circular_reveal.dart';

class GlowingCircle extends StatefulWidget {
  const GlowingCircle({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GlowingCircle> createState() => _GlowingCircleState();
}

class _GlowingCircleState extends State<GlowingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircularRevealAnimation(
      animation: animation,
      child: widget.child,
    );
  }
}
