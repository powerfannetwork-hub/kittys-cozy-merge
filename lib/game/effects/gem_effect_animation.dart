import 'package:flutter/material.dart';

import 'gem_effect.dart';

class GemEffectAnimation extends StatefulWidget {
  const GemEffectAnimation({
    super.key,
    required this.effect,
    this.duration = const Duration(
      milliseconds: 420,
    ),
    this.onComplete,
  });

  final GemEffect effect;
  final Duration duration;
  final VoidCallback? onComplete;

  @override
  State<GemEffectAnimation> createState() =>
      _GemEffectAnimationState();
}

class _GemEffectAnimationState
    extends State<GemEffectAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.addStatusListener(
      _handleAnimationStatus,
    );

    _controller.forward();
  }

  void _handleAnimationStatus(
    AnimationStatus status,
  ) {
    if (status == AnimationStatus.completed) {
      widget.onComplete?.call();
    }
  }

  @override
  void didUpdateWidget(
    covariant GemEffectAnimation oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.effect != widget.effect) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _progress,
          builder: (
            context,
            child,
          ) {
            return CustomPaint(
              painter: _AnimatedGemEffectPainter(
                effect: widget.effect,
                progress: _progress.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedGemEffectPainter
    extends CustomPainter {
  const _AnimatedGemEffectPainter({
    required this.effect,
    required this.progress,
  });

  final GemEffect effect;
  final double progress;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = effect.position;

    switch (effect.type) {
      case GemEffectType.match:
        _paintMatch(
          canvas,
          center,
        );
        break;

      case GemEffectType.rocketHorizontal:
        _paintRocket(
          canvas,
          center,
          horizontal: true,
        );
        break;

      case GemEffectType.rocketVertical:
        _paintRocket(
          canvas,
          center,
          horizontal: false,
        );
        break;

      case GemEffectType.bomb:
        _paintBomb(
          canvas,
          center,
        );
        break;

      case GemEffectType.colorBomb:
        _paintColorBomb(
          canvas,
          center,
        );
        break;

      case GemEffectType.sparkle:
        _paintSparkle(
          canvas,
          center,
        );
        break;
    }
  }

  void _paintMatch(
    Canvas canvas,
    Offset center,
  ) {
    final scale =
        0.35 + progress * 1.0;

    final opacity =
        (1.0 - progress).clamp(
      0.0,
      1.0,
    );

    final radius =
        9.0 * scale;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = effect.color.withOpacity(
        opacity * 0.85,
      );

    canvas.drawCircle(
      center,
      radius,
      ringPaint,
    );

    final corePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(
        opacity * 0.9,
      );

    canvas.drawCircle(
      center,
      3.0 * (1.0 - progress * 0.5),
      corePaint,
    );
  }

  void _paintRocket(
    Canvas canvas,
    Offset center, {
    required bool horizontal,
  }) {
    final progressValue = progress;

    final length =
        10.0 + progressValue * 32.0;

    final opacity =
        (1.0 - progressValue).clamp(
      0.0,
      1.0,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..color = effect.color.withOpacity(
        opacity,
      );

    if (horizontal) {
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

      canvas.drawLine(
        Offset(
          center.dx + length,
          center.dy,
        ),
        Offset(
          center.dx + length - 8,
          center.dy - 5,
        ),
        paint,
      );

      canvas.drawLine(
        Offset(
          center.dx + length,
          center.dy,
        ),
        Offset(
          center.dx + length - 8,
          center.dy + 5,
        ),
        paint,
      );
    } else {
      canvas.drawLine(
        Offset(
          center.dx,
          center.dy - length,
        ),
        Offset(
          center.dx,
          center.dy + length,
        ),
        paint,
      );

      canvas.drawLine(
        Offset(
          center.dx,
          center.dy - length,
        ),
        Offset(
          center.dx - 5,
          center.dy - length + 8,
        ),
        paint,
      );

      canvas.drawLine(
        Offset(
          center.dx,
          center.dy - length,
        ),
        Offset(
          center.dx + 5,
          center.dy - length + 8,
        ),
        paint,
      );
    }
  }

  void _paintBomb(
    Canvas canvas,
    Offset center,
  ) {
    final explosion =
        Curves.easeOut.transform(
      progress,
    );

    final radius =
        8.0 + explosion * 42.0;

    final opacity =
        (1.0 - explosion).clamp(
      0.0,
      1.0,
    );

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = effect.color.withOpacity(
        opacity,
      );

    canvas.drawCircle(
      center,
      radius,
      ringPaint,
    );

    final coreRadius =
        12.0 * (1.0 - explosion);

    if (coreRadius > 0) {
      final corePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = effect.color.withOpacity(
          opacity,
        );

      canvas.drawCircle(
        center,
        coreRadius,
        corePaint,
      );
    }
  }

  void _paintColorBomb(
    Canvas canvas,
    Offset center,
  ) {
    final value = Curves.easeOut.transform(
      progress,
    );

    final opacity =
        (1.0 - value).clamp(
      0.0,
      1.0,
    );

    final radius =
        7.0 + value * 30.0;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = effect.color.withOpacity(
        opacity,
      );

    canvas.drawCircle(
      center,
      radius,
      ringPaint,
    );

    const directions = <Offset>[
      Offset(0, -1),
      Offset(1, 0),
      Offset(0, 1),
      Offset(-1, 0),
      Offset(0.707, -0.707),
      Offset(0.707, 0.707),
      Offset(-0.707, 0.707),
      Offset(-0.707, -0.707),
    ];

    for (final direction in directions) {
      final distance =
          8.0 + value * 28.0;

      final point = center +
          direction * distance;

      final sparklePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = effect.color.withOpacity(
          opacity,
        );

      canvas.drawCircle(
        point,
        2.5 * (1.0 - value * 0.35),
        sparklePaint,
      );
    }
  }

  void _paintSparkle(
    Canvas canvas,
    Offset center,
  ) {
    final value =
        Curves.easeOut.transform(
      progress,
    );

    final opacity =
        (1.0 - value).clamp(
      0.0,
      1.0,
    );

    final length =
        5.0 + value * 15.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = effect.color.withOpacity(
        opacity,
      );

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

    canvas.drawLine(
      Offset(
        center.dx,
        center.dy - length,
      ),
      Offset(
        center.dx,
        center.dy + length,
      ),
      paint,
    );

    final diagonal =
        length * 0.7;

    canvas.drawLine(
      Offset(
        center.dx - diagonal,
        center.dy - diagonal,
      ),
      Offset(
        center.dx + diagonal,
        center.dy + diagonal,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(
        center.dx + diagonal,
        center.dy - diagonal,
      ),
      Offset(
        center.dx - diagonal,
        center.dy + diagonal,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _AnimatedGemEffectPainter oldDelegate,
  ) {
    return oldDelegate.effect != effect ||
        oldDelegate.progress != progress;
  }
}
