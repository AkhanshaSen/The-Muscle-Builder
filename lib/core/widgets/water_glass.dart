import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated glass of water that fills to [progress] (0–1) with a flowing wave.
class WaterGlass extends StatefulWidget {
  const WaterGlass({
    super.key,
    required this.progress,
    required this.color,
    this.width = 44,
    this.height = 58,
  });

  final double progress;
  final Color color;
  final double width;
  final double height;

  @override
  State<WaterGlass> createState() => _WaterGlassState();
}

class _WaterGlassState extends State<WaterGlass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _WaterGlassPainter(
              progress: widget.progress.clamp(0.0, 1.0),
              color: widget.color,
              phase: reduceMotion ? 0 : _controller.value * math.pi * 2,
              animate: !reduceMotion,
            ),
          );
        },
      ),
    );
  }
}

class _WaterGlassPainter extends CustomPainter {
  _WaterGlassPainter({
    required this.progress,
    required this.color,
    required this.phase,
    required this.animate,
  });

  final double progress;
  final Color color;
  final double phase;
  final bool animate;

  @override
  void paint(Canvas canvas, Size size) {
    final glass = _glassPath(size);
    final rim = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, 0, size.width * 0.84, size.height * 0.06),
      const Radius.circular(3),
    );

    // Outer glass fill (subtle)
    canvas.drawPath(
      glass,
      Paint()
        ..color = color.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );

    // Clip water to glass
    canvas.save();
    canvas.clipPath(glass);

    final waterTop = size.height * (1 - progress);
    if (progress > 0.01) {
      final waterPath = Path();
      waterPath.moveTo(0, size.height);
      waterPath.lineTo(size.width, size.height);
      waterPath.lineTo(size.width, waterTop);

      if (animate && progress < 0.98) {
        const amp1 = 2.2;
        const amp2 = 1.4;
        const waves = 1.6;
        for (var x = size.width; x >= 0; x -= 1.5) {
          final t = x / size.width;
          final y = waterTop +
              math.sin(t * math.pi * waves + phase) * amp1 +
              math.sin(t * math.pi * waves * 1.7 - phase * 1.3) * amp2;
          waterPath.lineTo(x, y);
        }
      } else {
        waterPath.lineTo(0, waterTop);
      }
      waterPath.close();

      final fill = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.55),
            color.withValues(alpha: 0.92),
          ],
        ).createShader(Rect.fromLTWH(0, waterTop, size.width, size.height - waterTop));
      canvas.drawPath(waterPath, fill);

      // Highlight band near the surface
      final highlight = Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(size.width * 0.18, waterTop + 3),
        Offset(size.width * 0.55, waterTop + 3),
        highlight,
      );
    }

    canvas.restore();

    // Glass outline
    canvas.drawPath(
      glass,
      Paint()
        ..color = color.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    canvas.drawRRect(
      rim,
      Paint()
        ..color = color.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Side highlight
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.18),
      Offset(size.width * 0.18, size.height * 0.85),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  Path _glassPath(Size size) {
    final topL = Offset(size.width * 0.16, size.height * 0.08);
    final topR = Offset(size.width * 0.84, size.height * 0.08);
    final botL = Offset(size.width * 0.24, size.height * 0.96);
    final botR = Offset(size.width * 0.76, size.height * 0.96);
    return Path()
      ..moveTo(topL.dx, topL.dy)
      ..lineTo(topR.dx, topR.dy)
      ..lineTo(botR.dx, botR.dy)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 1.02,
        botL.dx,
        botL.dy,
      )
      ..close();
  }

  @override
  bool shouldRepaint(covariant _WaterGlassPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.phase != phase ||
        oldDelegate.animate != animate;
  }
}
