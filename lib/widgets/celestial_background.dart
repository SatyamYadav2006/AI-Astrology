import 'dart:math' as math;
import 'package:flutter/material.dart';

class CelestialBackground extends StatefulWidget {
  final Widget child;

  const CelestialBackground({super.key, required this.child});

  @override
  _CelestialBackgroundState createState() => _CelestialBackgroundState();
}

class _CelestialBackgroundState extends State<CelestialBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final List<Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat();
    _stars = List.generate(80, (index) => Star.random()); // Reduced from 150
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      children: [
        // Solid deepest space
        Container(
          color: isDark ? const Color(0xFF02040A) : const Color(0xFFE8ECEF),
        ),
        
        // Custom Painter for Stars and Astrolabe
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _CelestialPainter(
                    animation: _controller.value,
                    stars: _stars,
                    isDark: isDark,
                    primaryColor: Theme.of(context).colorScheme.primary,
                    tertiaryColor: Theme.of(context).colorScheme.tertiary,
                  ),
                );
              },
            ),
          ),
        ),

        // Foreground content
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class Star {
  double x, y, size, shimmerSpeed, shimmerPhase;
  
  Star({required this.x, required this.y, required this.size, required this.shimmerSpeed, required this.shimmerPhase});

  factory Star.random() {
    final random = math.Random();
    return Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 2 + 0.5,
      shimmerSpeed: random.nextDouble() * 3 + 1,
      shimmerPhase: random.nextDouble() * math.pi * 2,
    );
  }
}

class _CelestialPainter extends CustomPainter {
  final double animation;
  final List<Star> stars;
  final bool isDark;
  final Color primaryColor;
  final Color tertiaryColor;

  _CelestialPainter({
    required this.animation,
    required this.stars,
    required this.isDark,
    required this.primaryColor,
    required this.tertiaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawStars(canvas, size);
    _drawRadialGlow(canvas, size);
    _drawAstrolabe(canvas, size);
  }

  void _drawRadialGlow(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.3),
        radius: 1.2,
        colors: [
          primaryColor.withOpacity(isDark ? 0.2 : 0.1),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()..color = isDark ? Colors.white : Colors.black87;
    for (var star in stars) {
      double rawOpacity = (math.sin(animation * math.pi * 2 * star.shimmerSpeed + star.shimmerPhase) + 1) / 2;
      double opacity = rawOpacity * (isDark ? 0.8 : 0.3) + 0.1;
      
      paint.color = (isDark ? Colors.white : Colors.black87).withOpacity(opacity.clamp(0.0, 1.0));
      double dx = star.x * size.width;
      double dy = star.y * size.height;
      canvas.drawCircle(Offset(dx, dy), star.size, paint);
    }
  }

  void _drawAstrolabe(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.2); // Positioned near the top hero graphic
    final maxRadius = size.width * 0.9;
    
    // Draw rotating concentric rings
    _drawDashedRing(canvas, center, maxRadius * 0.3, animation * math.pi * 2, 24, 0.5);
    _drawDashedRing(canvas, center, maxRadius * 0.5, -animation * math.pi * 2 * 0.8, 36, 0.3);
    _drawSolidRing(canvas, center, maxRadius * 0.65, 0.2);
    _drawTickRing(canvas, center, maxRadius * 0.8, animation * math.pi * 2 * 0.5, 72, 0.4);
    
    // Draw intricate crossing lines
    final linePaint = Paint()
      ..color = tertiaryColor.withOpacity(isDark ? 0.15 : 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
      
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(animation * math.pi * 2 * 0.2);
    for (int i = 0; i < 12; i++) {
        canvas.drawLine(Offset.zero, Offset(maxRadius * 0.75, 0), linePaint);
        canvas.rotate(math.pi / 6);
    }
    
    // Inner glowing sphere
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [tertiaryColor.withOpacity(0.3), Colors.transparent]
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: maxRadius * 0.2));
    canvas.drawCircle(Offset.zero, maxRadius * 0.2, glowPaint);
    
    canvas.restore();
  }

  void _drawSolidRing(Canvas canvas, Offset center, double radius, double opacity) {
    final ringPaint = Paint()
      ..color = tertiaryColor.withOpacity(isDark ? opacity : opacity + 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius, ringPaint);
  }

  void _drawDashedRing(Canvas canvas, Offset center, double radius, double rotation, int segments, double opacity) {
    final ringPaint = Paint()
      ..color = primaryColor.withOpacity(isDark ? opacity : opacity + 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double dashAngle = (math.pi * 2) / (segments * 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    for (int i = 0; i < segments; i++) {
      Path path = Path();
      path.addArc(Rect.fromCircle(center: Offset.zero, radius: radius), 0, dashAngle);
      canvas.drawPath(path, ringPaint);
      canvas.rotate(dashAngle * 2);
    }
    canvas.restore();
  }
  
  void _drawTickRing(Canvas canvas, Offset center, double radius, double rotation, int ticks, double opacity) {
    final ringPaint = Paint()
      ..color = tertiaryColor.withOpacity(isDark ? opacity : opacity + 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final double tickAngle = (math.pi * 2) / ticks;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    for (int i = 0; i < ticks; i++) {
      double tickLength = (i % 6 == 0) ? 10.0 : 4.0;
      canvas.drawLine(Offset(radius, 0), Offset(radius + tickLength, 0), ringPaint);
      canvas.rotate(tickAngle);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CelestialPainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.isDark != isDark;
  }
}
