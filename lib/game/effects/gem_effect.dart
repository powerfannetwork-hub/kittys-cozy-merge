import 'package:flutter/material.dart';

enum GemEffectType {
  match,
  rocketHorizontal,
  rocketVertical,
  bomb,
  colorBomb,
  sparkle,
}

class GemEffect {
  const GemEffect({
    required this.position,
    required this.type,
    this.color = Colors.white,
  });

  final Offset position;
  final GemEffectType type;
  final Color color;
}

class GemEffectPainter extends CustomPainter {
  const GemEffectPainter({
    required this.effects,
  });

  final List<GemEffect> effects;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    for (final effect in effects) {
      _paintEffect(
        canvas,
        effect,
      );
    }
  }

  void _paintEffect(
    Canvas canvas,
    GemEffect effect,
  ) {
    switch (effect.type) {
      case GemEffectType.match:
        _paintMatch(
          canvas,
          effect,
        );
        break;

      case GemEffectType.rocketHorizontal:
        _paintRocket(
          canvas,
          effect,
          horizontal: true,
        );
        break;

      case GemEffectType.rocketVertical:
        _paintRocket(
          canvas,
          effect,
          horizontal: false,
        );
        break;

      case GemEffectType.bomb:
        _paintBomb(
          canvas,
          effect,
        );
        break;

      case GemEffectType.colorBomb:
        _paintColorBomb(
          canvas,
          effect,
        );
        break;

      case GemEffectType.sparkle:
        _paintSparkle(
          canvas,
          effect,
        );
        break;
    }
  }

  void _paintMatch(
    Canvas canvas,
    GemEffect effect,
  ) {
    final paint = Paint()
      ..color = effect.color.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
      effect.position,
      12,
      paint,
    );

    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      effect.position,
      3,
      innerPaint,
    );
  }

  void _paintRocket(
    Canvas canvas,
    GemEffect effect, {
    required bool horizontal,
  }) {
    final paint = Paint()
      ..color = effect.color.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = effect.position;

    if (horizontal) {
      canvas.drawLine(
        Offset(center.dx - 15, center.dy),
        Offset(center.dx + 15, center.dy),
        paint,
      );

      canvas.drawLine(
        Offset(center.dx + 9, center.dy - 6),
        Offset(center.dx + 15, center.dy),
        paint,
      );

      canvas.drawLine(
        Offset(center.dx + 9, center.dy + 6),
        Offset(center.dx + 15, center.dy),
        paint,
      );
    } else {
      canvas.drawLine(
        Offset(center.dx, center.dy - 15),
        Offset(center.dx, center.dy + 15),
        paint,
      );

      canvas.drawLine(
        Offset(center.dx - 6, center.dy - 9),
        Offset(center.dx, center.dy - 15),
        paint,
      );

      canvas.drawLine(
        Offset(center.dx + 6, center.dy - 9),
        Offset(center.dx, center.dy - 15),
        paint,
      );
    }
  }

  void _paintBomb(
    Canvas canvas,
    GemEffect effect,
  ) {
    final center = effect.position;

    final outerPaint = Paint()
      ..color = effect.color.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      17,
      outerPaint,
    );

    final ringPaint = Paint()
      ..color = effect.color.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
      center,
      11,
      ringPaint,
    );

    final corePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      4,
      corePaint,
    );
  }

  void _paintColorBomb(
    Canvas canvas,
    GemEffect effect,
  ) {
    final center = effect.position;

    final paint = Paint()
      ..color = effect.color.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
      center,
      14,
      paint,
    );

    const directions = <Offset>[
      Offset(0, -1),
      Offset(1, 0),
      Offset(0, 1),
      Offset(-1, 0),
      Offset(0.7, -0.7),
      Offset(0.7, 0.7),
      Offset(-0.7, 0.7),
      Offset(-0.7, -0.7),
    ];

    for (final direction in directions) {
      canvas.drawLine(
        center + direction * 5,
        center + direction * 12,
        paint,
      );
    }
  }

  void _paintSparkle(
    Canvas canvas,
    GemEffect effect,
  ) {
    final center = effect.position;

    final paint = Paint()
      ..color = effect.color.withOpacity(0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx, center.dy - 12),
      Offset(center.dx, center.dy + 12),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx - 12, center.dy),
      Offset(center.dx + 12, center.dy),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx - 8, center.dy - 8),
      Offset(center.dx + 8, center.dy + 8),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx + 8, center.dy - 8),
      Offset(center.dx - 8, center.dy + 8),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant GemEffectPainter oldDelegate,
  ) {
    return oldDelegate.effects != effects;
  }
}

class GemEffectLayer extends StatelessWidget {
  const GemEffectLayer({
    super.key,
    required this.effects,
  });

  final List<GemEffect> effects;

  @override
  Widget build(BuildContext context) {
    if (effects.isEmpty) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: CustomPaint(
        painter: GemEffectPainter(
          effects: effects,
        ),
        size: Size.infinite,
      ),
    );
  }
}
