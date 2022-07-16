import 'dart:math';

import 'package:flutter/material.dart';

class OnHoverFly extends StatefulWidget {
  const OnHoverFly({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<OnHoverFly> createState() => _OnHoverFlyState();
}

class _OnHoverFlyState extends State<OnHoverFly> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  bool isHover = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0, sin(_controller.value * 2 * pi) * 10),
          child: child,
        );
      },
      animation: _controller,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hover) {
          setState(() {
            isHover = hover;
            hover ? _controller.forward() : _controller.reset();
          });
        },
        child: widget.child,
      ),
    );
  }
}
