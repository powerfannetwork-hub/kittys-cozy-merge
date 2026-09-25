import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'game_animation_controller.dart';

class GameAnimationLayer extends StatelessWidget {
  const GameAnimationLayer({
    super.key,
    required this.controller,
    this.child,
    this.size = const Size(
      double.infinity,
      double.infinity,
    ),
  });

  final GameAnimationController controller;
  final Widget? child;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (
        context,
        child,
      ) {
        if (!controller.isRunning ||
            controller.currentRequest == null) {
          return child ?? const SizedBox.shrink();
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            if (child != null) child,
            IgnorePointer(
              child: CustomPaint(
                painter: _GameAnimationPainter(
                  request: controller.currentRequest!,
                  progress: controller.progress,
                ),
                size: size,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GameAnimationPainter extends CustomPainter {
  const _GameAnimationPainter({
    required this.request,
    required this.progress,
  });

  final GameAnimationRequest request;
  final double progress;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (size.isEmpty) {
      return;
    }

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    switch (request.type) {
      case GameAnimationType.swap:
        _drawSwap(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.swapBack:
        _drawSwapBack(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.gemMatch:
        _drawMatch(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.gemCollect:
        _drawCollect(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.gemFall:
        _drawFall(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.specialGem:
        _drawSpecial(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.bomb:
        _drawBomb(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.rocket:
        _drawRocket(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.colorBomb:
        _drawColorBomb(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.invalidMove:
        _drawInvalidMove(
          canvas,
          center,
          size,
        );
        break;

      case GameAnimationType.goalComplete:
        _drawGoalComplete(
          canvas,
          center,
          size,
        );
        break;
    }
  }

  void _drawSwap(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    final radius = size.shortestSide *
        (0.12 + value * 0.05);

    _drawRing(
      canvas,
      center,
      radius,
      const Color(0xFFFF78B7),
      0.34 * (1.0 - value),
    );
  }

  void _drawSwapBack(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    final radius = size.shortestSide *
        (0.10 + value * 0.06);

    _drawRing(
      canvas,
      center,
      radius,
      const Color(0xFFFFA5C9),
      0.30 * (1.0 - value),
    );
  }

  void _drawMatch(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    final radius = size.shortestSide *
        (0.08 + value * 0.20);

    final opacity = 0.42 * (1.0 - value);

    _drawRing(
      canvas,
      center,
      radius,
      const Color(0xFFFFC6DF),
      opacity,
    );

    _drawSparkles(
      canvas,
      center,
      size,
      value,
      const Color(0xFFFF78B7),
    );
  }

  void _drawCollect(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    _drawSparkles(
      canvas,
      center,
      size,
      value,
      const Color(0xFFFFD76A),
    );
  }

  void _drawFall(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    final opacity =
        0.20 * math.sin(value * math.pi);

    final paint = Paint()
      ..color = Colors.white.withOpacity(
        opacity.clamp(0.0, 1.0),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      size.shortestSide * 0.07,
      paint,
    );
  }

  void _drawSpecial(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    _drawRing(
      canvas,
      center,
      size.shortestSide *
          (0.10 + value * 0.16),
      const Color(0xFFFFD76A),
      0.50 * (1.0 - value),
    );

    _drawSparkles(
      canvas,
      center,
      size,
      value,
      const Color(0xFFFFD76A),
    );
  }

  void _drawBomb(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    final radius = size.shortestSide *
        (0.07 + value * 0.27);

    _drawRing(
      canvas,
      center,
      radius,
      const Color(0xFFFF8A65),
      0.55 * (1.0 - value),
    );

    _drawShockwave(
      canvas,
      center,
      size,
      value,
      const Color(0xFFFFC857),
    );
  }

  void _drawRocket(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    final length = size.width *
        (0.18 + value * 0.28);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.035
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFF78B7)
          .withOpacity(0.72 * (1.0 - value));

    canvas.drawLine(
      Offset(
        center.dx - length,
        center.dy,
      ),
      Offset(
        center.dx + length,
        center.dy,
      ),
      paint,
    );

    _drawSparkles(
      canvas,
      center,
      size,
      value,
      const Color(0xFFFFE08A),
    );
  }

  void _drawColorBomb(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    _drawRing(
      canvas,
      center,
      size.shortestSide *
          (0.10 + value * 0.30),
      const Color(0xFFB88CFF),
      0.50 * (1.0 - value),
    );

    final colors = <Color>[
      const Color(0xFFFF78B7),
      const Color(0xFF6DB6FF),
      const Color(0xFF9BE28F),
      const Color(0xFFFFD76A),
      const Color(0xFFB88CFF),
    ];

    for (int index = 0;
        index < colors.length;
        index++) {
      final angle =
          (math.pi * 2 / colors.length) * index;

      final distance =
          size.shortestSide *
              (0.10 + value * 0.22);

      final point = Offset(
        center.dx +
            math.cos(angle) * distance,
        center.dy +
            math.sin(angle) * distance,
      );

      final paint = Paint()
        ..color = colors[index]
            .withOpacity(0.75 * (1.0 - value))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        point,
        size.shortestSide * 0.025,
        paint,
      );
    }
  }

  void _drawInvalidMove(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final wave =
        math.sin(progress * math.pi);

    final paint = Paint()
      ..color = const Color(0xFFFF6F91)
          .withOpacity(0.45 * wave)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.035
      ..strokeCap = StrokeCap.round;

    final offset =
        size.shortestSide *
            0.08 *
            math.sin(progress * math.pi * 2);

    canvas.drawLine(
      Offset(
        center.dx - size.width * 0.12 + offset,
        center.dy - size.height * 0.08,
      ),
      Offset(
        center.dx + size.width * 0.12 + offset,
        center.dy + size.height * 0.08,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(
        center.dx + size.width * 0.12 + offset,
        center.dy - size.height * 0.08,
      ),
      Offset(
        center.dx - size.width * 0.12 + offset,
        center.dy + size.height * 0.08,
      ),
      paint,
    );
  }

  void _drawGoalComplete(
    Canvas canvas,
    Offset center,
    Size size,
  ) {
    final value = Curves.easeOut.transform(
      progress.clamp(0.0, 1.0),
    );

    final radius = size.shortestSide *
        (0.10 + value * 0.28);

    _drawRing(
      canvas,
      center,
      radius,
      const Color(0xFFFFD76A),
      0.60 * (1.0 - value),
    );

    _drawSparkles(
      canvas,
      center,
      size,
      value,
      const Color(0xFFFFD76A),
    );

    final checkPaint = Paint()
      ..color = const Color(0xFFFFD76A)
          .withOpacity(0.80 * (1.0 - value))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.045
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final checkPath = Path();

    checkPath.moveTo(
      center.dx - size.width * 0.10,
      center.dy,
    );

    checkPath.lineTo(
      center.dx - size.width * 0.02,
      center.dy + size.height * 0.08,
    );

    checkPath.lineTo(
      center.dx + size.width * 0.13,
      center.dy - size.height * 0.10,
    );

    canvas.drawPath(
      checkPath,
      checkPaint,
    );
  }

  void _drawRing(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double opacity,
  ) {
    if (opacity <= 0.0 || radius <= 0.0) {
      return;
    }

    final paint = Paint()
      ..color = color.withOpacity(
        opacity.clamp(0.0, 1.0),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.14;

    canvas.drawCircle(
      center,
      radius,
      paint,
    );
  }

  void _drawShockwave(
    Canvas canvas,
    Offset center,
    Size size,
    double progress,
    Color color,
  ) {
    final radius =
        size.shortestSide *
            (0.08 + progress * 0.32);

    final paint = Paint()
      ..color = color.withOpacity(
        0.48 * (1.0 - progress),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          size.shortestSide * 0.025;

    canvas.drawCircle(
      center,
      radius,
      paint,
    );
  }

  void _drawSparkles(
    Canvas canvas,
    Offset center,
    Size size,
    double progress,
    Color color,
  ) {
    final count = 8;

    for (int index = 0; index < count; index++) {
      final angle =
          (math.pi * 2 / count) * index;

      final distance =
          size.shortestSide *
              (0.12 + progress * 0.28);

      final point = Offset(
        center.dx +
            math.cos(angle) * distance,
        center.dy +
            math.sin(angle) * distance,
      );

      final opacity =
          0.70 * (1.0 - progress);

      if (opacity <= 0.0) {
        continue;
      }

      final paint = Paint()
        ..color = color.withOpacity(
          opacity.clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill;

      final sparkleSize =
          size.shortestSide *
              (0.018 + (1.0 - progress) * 0.025);

      final path = Path();

      path.moveTo(
        point.dx,
        point.dy - sparkleSize,
      );

      path.lineTo(
        point.dx + sparkleSize * 0.35,
        point.dy,
      );

      path.lineTo(
        point.dx,
        point.dy + sparkleSize,
      );

      path.lineTo(
        point.dx - sparkleSize * 0.35,
        point.dy,
      );

      path.close();

      canvas.drawPath(
        path,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    _GameAnimationPainter oldDelegate,
  ) {
    return oldDelegate.request != request ||
        oldDelegate.progress != progress;
  }
}
