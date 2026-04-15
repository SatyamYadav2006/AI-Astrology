import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CosmicBackground extends StatelessWidget {
  final Widget child;

  const CosmicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Solid deepest background
        Container(
          color: isDark ? const Color(0xFF020617) : const Color(0xFFEEF2FF),
        ),
        
        // Blobs with flutter_animate movement
        Positioned(
          top: -100,
          left: -100,
          child: _buildBlob(context, Theme.of(context).colorScheme.primary.withOpacity(isDark ? 0.4 : 0.2), 300)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .move(duration: 8000.ms, begin: const Offset(0, 0), end: const Offset(60, 60))
            .scale(duration: 6000.ms, begin: const Offset(1, 1), end: const Offset(1.3, 1.3)),
        ),
        
        Positioned(
          bottom: -50,
          right: -50,
          child: _buildBlob(context, Theme.of(context).colorScheme.secondary.withOpacity(isDark ? 0.35 : 0.2), 350)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .move(duration: 10000.ms, begin: const Offset(0, 0), end: const Offset(-50, -50))
            .scale(duration: 7000.ms, begin: const Offset(1.2, 1.2), end: const Offset(0.9, 0.9)),
        ),
        
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          right: -100,
          child: _buildBlob(context, Theme.of(context).colorScheme.tertiary.withOpacity(isDark ? 0.2 : 0.15), 250)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .move(duration: 9000.ms, begin: const Offset(-40, 20), end: const Offset(40, -20)),
        ),

        // Foreground content
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _buildBlob(BuildContext context, Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size / 1.5,
            spreadRadius: size / 3,
          )
        ]
      ),
    );
  }
}
