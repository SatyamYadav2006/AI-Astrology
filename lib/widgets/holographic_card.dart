import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class HolographicCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const HolographicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
  });

  @override
  _HolographicCardState createState() => _HolographicCardState();
}

class _HolographicCardState extends State<HolographicCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: SweepGradient(
              transform: GradientRotation(_controller.value * math.pi * 2),
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
              stops: const [0.0, 0.33, 0.66, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: -2,
              )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5), // The thin glowing border
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF050B14).withOpacity(0.92) : Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(22.5),
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
