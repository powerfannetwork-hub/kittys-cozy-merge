import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/gem_type.dart';
import 'gem.dart';

class GemWidget extends StatelessWidget {
  const GemWidget({
    super.key,
    required this.gem,
    this.size = 48,
    this.selected = false,
    this.enabled = true,
  });

  final Gem gem;
  final double size;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final double safeSize = size < 1 ? 1 : size;

    return SizedBox(
      width: safeSize,
      height: safeSize,
      child: CustomPaint(
        painter: _GemPainter(
          gem: gem,
          selected: selected,
          enabled: enabled,
        ),
      ),
    );
  }
}

class _GemPainter extends CustomPainter {
  const _GemPainter({
    required this.gem,
    required this.selected,
    required this.enabled,
  });

  final Gem gem;
  final bool selected;
  final bool enabled;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    final Offset center = size.center(Offset.zero);
    final double shortestSide = math.min(
      size.width,
      size.height,
    );

    final double radius = shortestSide * 0.40;

    if (selected) {
      _drawSelectionGlow(
        canvas,
        center,
        radius,
      );
    }

    _drawShadow(
      canvas,
      center,
      radius,
    );

    switch (gem.specialType) {
      case GemSpecialType.normal:
        _drawNormalGem(
          canvas,
          center,
          radius,
        );
        break;

      case GemSpecialType.rocketHorizontal:
        _drawNormalGem(
          canvas,
          center,
          radius,
        );
        _drawRocket(
          canvas,
          center,
          radius,
          horizontal: true,
        );
        break;

      case GemSpecialType.rocketVertical:
        _drawNormalGem(
          canvas,
          center,
          radius,
        );
        _drawRocket(
          canvas,
          center,
          radius,
          horizontal: false,
        );
        break;

      case GemSpecialType.bomb:
        _drawNormalGem(
          canvas,
          center,
          radius,
        );
        _drawBomb(
          canvas,
          center,
          radius,
        );
        break;

      case GemSpecialType.colorBomb:
        _drawColorBomb(
          canvas,
          center,
          radius,
        );
        break;
    }

    if (!enabled) {
      _drawDisabledOverlay(
        canvas,
        center,
        radius,
      );
    }
  }

  void _drawSelectionGlow(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final Paint glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.72)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        7,
      );

    canvas.drawCircle(
      center,
      radius * 1.20,
      glowPaint,
    );

    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.11
      ..color = Colors.white.withOpacity(0.92);

    canvas.drawCircle(
      center,
      radius * 1.06,
      ringPaint,
    );
  }

  void _drawShadow(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.22)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        3.5,
      );

    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(
          0,
          radius * 0.17,
        ),
        width: radius * 1.75,
        height: radius * 0.82,
      ),
      shadowPaint,
    );
  }

  void _drawNormalGem(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final Color baseColor = _baseColor(gem.type);
    final Color darkColor = _darkColor(gem.type);
    final Color lightColor = _lightColor(gem.type);

    final Path gemPath = _createGemPath(
      center: center,
      radius: radius,
    );

    final Rect bounds = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final Paint bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          lightColor,
          baseColor,
          darkColor,
        ],
        stops: const <double>[
          0.0,
          0.48,
          1.0,
        ],
      ).createShader(bounds);

    canvas.drawPath(
      gemPath,
      bodyPaint,
    );

    final Paint outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.055
      ..color = darkColor.withOpacity(0.65);

    canvas.drawPath(
      gemPath,
      outlinePaint,
    );

    _drawGemFacets(
      canvas,
      center,
      radius,
      lightColor,
    );

    _drawGemHighlight(
      canvas,
      center,
      radius,
    );
  }

  Path _createGemPath({
    required Offset center,
    required double radius,
  }) {
    final Path path = Path();

    const int points = 8;

    for (int index = 0; index < points; index++) {
      final double angle =
          (-math.pi / 2) + (index * math.pi / 4);

      final double pointRadius = index.isEven
          ? radius
          : radius * 0.78;

      final Offset point = Offset(
        center.dx +
            math.cos(angle) * pointRadius,
        center.dy +
            math.sin(angle) * pointRadius,
      );

      if (index == 0) {
        path.moveTo(
          point.dx,
          point.dy,
        );
      } else {
        path.lineTo(
          point.dx,
          point.dy,
        );
      }
    }

    path.close();

    return path;
  }

  void _drawGemFacets(
    Canvas canvas,
    Offset center,
    double radius,
    Color lightColor,
  ) {
    final Path topFacet = Path()
      ..moveTo(
        center.dx,
        center.dy - radius * 0.78,
      )
      ..lineTo(
        center.dx + radius * 0.57,
        center.dy - radius * 0.24,
      )
      ..lineTo(
        center.dx,
        center.dy - radius * 0.04,
      )
      ..lineTo(
        center.dx - radius * 0.57,
        center.dy - radius * 0.24,
      )
      ..close();

    final Paint facetPaint = Paint()
      ..color = lightColor.withOpacity(0.28);

    canvas.drawPath(
      topFacet,
      facetPaint,
    );

    final Path leftFacet = Path()
      ..moveTo(
        center.dx - radius * 0.78,
        center.dy,
      )
      ..lineTo(
        center.dx - radius * 0.57,
        center.dy - radius * 0.24,
      )
      ..lineTo(
        center.dx,
        center.dy - radius * 0.04,
      )
      ..lineTo(
        center.dx - radius * 0.22,
        center.dy + radius * 0.58,
      )
      ..close();

    canvas.drawPath(
      leftFacet,
      Paint()
        ..color = Colors.white.withOpacity(0.10),
    );

    final Path rightFacet = Path()
      ..moveTo(
        center.dx + radius * 0.78,
        center.dy,
      )
      ..lineTo(
        center.dx + radius * 0.57,
        center.dy - radius * 0.24,
      )
      ..lineTo(
        center.dx,
        center.dy - radius * 0.04,
      )
      ..lineTo(
        center.dx + radius * 0.22,
        center.dy + radius * 0.58,
      )
      ..close();

    canvas.drawPath(
      rightFacet,
      Paint()
        ..color = Colors.black.withOpacity(0.08),
    );
  }

  void _drawGemHighlight(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final Paint highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.82);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx - radius * 0.25,
          center.dy - radius * 0.28,
        ),
        width: radius * 0.38,
        height: radius * 0.18,
      ),
      highlightPaint,
    );

    final Paint smallHighlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.48);

    canvas.drawCircle(
      Offset(
        center.dx + radius * 0.28,
        center.dy - radius * 0.42,
      ),
      radius * 0.07,
      smallHighlightPaint,
    );
  }

  void _drawRocket(
    Canvas canvas,
    Offset center,
    double radius, {
    required bool horizontal,
  }) {
    canvas.save();

    if (!horizontal) {
      canvas.rotate(math.pi / 2, center: center);
    }

    final double rocketWidth = radius * 1.05;
    final double rocketHeight = radius * 0.36;

    final Rect rocketRect = Rect.fromCenter(
      center: center,
      width: rocketWidth,
      height: rocketHeight,
    );

    final RRect rocketBody = RRect.fromRectAndRadius(
      rocketRect,
      Radius.circular(radius * 0.18),
    );

    final Paint rocketPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFFFFFFFF),
          Color(0xFFEAF2FF),
        ],
      ).createShader(rocketRect);

    canvas.drawRRect(
      rocketBody,
      rocketPaint,
    );

    final Paint rocketOutline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.045
      ..color = const Color(0xFF8E6DB8);

    canvas.drawRRect(
      rocketBody,
      rocketOutline,
    );

    final Path nose = Path()
      ..moveTo(
        center.dx + rocketWidth * 0.50,
        center.dy,
      )
      ..lineTo(
        center.dx + rocketWidth * 0.26,
        center.dy - rocketHeight * 0.50,
      )
      ..lineTo(
        center.dx + rocketWidth * 0.26,
        center.dy + rocketHeight * 0.50,
      )
      ..close();

    canvas.drawPath(
      nose,
      Paint()..color = const Color(0xFFFF79B7),
    );

    final Paint windowPaint = Paint()
      ..color = const Color(0xFF7E61D8);

    canvas.drawCircle(
      Offset(
        center.dx + radius * 0.04,
        center.dy,
      ),
      radius * 0.11,
      windowPaint,
    );

    final Paint flamePaint = Paint()
      ..color = const Color(0xFFFFC857);

    final Path flame = Path()
      ..moveTo(
        center.dx - rocketWidth * 0.50,
        center.dy,
      )
      ..lineTo(
        center.dx - rocketWidth * 0.70,
        center.dy - rocketHeight * 0.48,
      )
      ..lineTo(
        center.dx - rocketWidth * 0.62,
        center.dy,
      )
      ..lineTo(
        center.dx - rocketWidth * 0.70,
        center.dy + rocketHeight * 0.48,
      )
      ..close();

    canvas.drawPath(
      flame,
      flamePaint,
    );

    canvas.restore();
  }

  void _drawBomb(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final Paint bombPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.45),
        radius: 1.0,
        colors: <Color>[
          Color(0xFF6F5C8D),
          Color(0xFF49355F),
          Color(0xFF2E233D),
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius * 0.68,
        ),
      );

    canvas.drawCircle(
      center,
      radius * 0.66,
      bombPaint,
    );

    final Paint outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..color = const Color(0xFF251B32);

    canvas.drawCircle(
      center,
      radius * 0.66,
      outlinePaint,
    );

    final Paint shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.72);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx - radius * 0.24,
          center.dy - radius * 0.25,
        ),
        width: radius * 0.28,
        height: radius * 0.13,
      ),
      shinePaint,
    );

    final Paint fusePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.075
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF5B4530);

    final Path fuse = Path()
      ..moveTo(
        center.dx + radius * 0.42,
        center.dy - radius * 0.48,
      )
      ..cubicTo(
        center.dx + radius * 0.72,
        center.dy - radius * 0.76,
        center.dx + radius * 0.68,
        center.dy - radius * 0.28,
        center.dx + radius * 0.83,
        center.dy - radius * 0.38,
      );

    canvas.drawPath(
      fuse,
      fusePaint,
    );

    final Paint sparkPaint = Paint()
      ..color = const Color(0xFFFFC857);

    canvas.drawCircle(
      Offset(
        center.dx + radius * 0.84,
        center.dy - radius * 0.39,
      ),
      radius * 0.12,
      sparkPaint,
    );
  }

  void _drawColorBomb(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final Rect bounds = Rect.fromCircle(
      center: center,
      radius: radius * 0.70,
    );

    final Paint bombPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.30, -0.38),
        radius: 1.0,
        colors: <Color>[
          Color(0xFFFFFFFF),
          Color(0xFFD7D2E8),
          Color(0xFF5B506F),
        ],
        stops: <double>[
          0.0,
          0.48,
          1.0,
        ],
      ).createShader(bounds);

    canvas.drawCircle(
      center,
      radius * 0.70,
      bombPaint,
    );

    final Paint outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..color = const Color(0xFF554968);

    canvas.drawCircle(
      center,
      radius * 0.70,
      outlinePaint,
    );

    final List<Color> sparkColors = <Color>[
      const Color(0xFFFF78B7),
      const Color(0xFF6EC6FF),
      const Color(0xFF8D7BFF),
      const Color(0xFF67D99A),
      const Color(0xFFFFC857),
      const Color(0xFFFF9866),
    ];

    for (int index = 0;
        index < sparkColors.length;
        index++) {
      final double angle =
          (math.pi * 2 / sparkColors.length) * index -
              math.pi / 2;

      final double distance = radius * 0.48;

      final Offset sparkCenter = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      final Paint sparkPaint = Paint()
        ..color = sparkColors[index];

      canvas.drawCircle(
        sparkCenter,
        radius * 0.105,
        sparkPaint,
      );
    }

    final Paint centerPaint = Paint()
      ..color = Colors.white.withOpacity(0.9);

    canvas.drawCircle(
      center,
      radius * 0.13,
      centerPaint,
    );

    final Paint highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.82);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx - radius * 0.25,
          center.dy - radius * 0.29,
        ),
        width: radius * 0.34,
        height: radius * 0.14,
      ),
      highlightPaint,
    );
  }

  void _drawDisabledOverlay(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final Paint overlayPaint = Paint()
      ..color = Colors.white.withOpacity(0.42);

    canvas.drawCircle(
      center,
      radius * 1.02,
      overlayPaint,
    );
  }

  Color _baseColor(GemType type) {
    switch (type) {
      case GemType.pink:
        return const Color(0xFFFF5FA2);
      case GemType.blue:
        return const Color(0xFF4DA9FF);
      case GemType.purple:
        return const Color(0xFF9B6CFF);
      case GemType.green:
        return const Color(0xFF52D38A);
      case GemType.yellow:
        return const Color(0xFFFFC94A);
      case GemType.orange:
        return const Color(0xFFFF9854);
    }
  }

  Color _darkColor(GemType type) {
    switch (type) {
      case GemType.pink:
        return const Color(0xFFC62D72);
      case GemType.blue:
        return const Color(0xFF2372C4);
      case GemType.purple:
        return const Color(0xFF6340B8);
      case GemType.green:
        return const Color(0xFF278F5A);
      case GemType.yellow:
        return const Color(0xFFD79612);
      case GemType.orange:
        return const Color(0xFFD65B22);
    }
  }

  Color _lightColor(GemType type) {
    switch (type) {
      case GemType.pink:
        return const Color(0xFFFFB7D3);
      case GemType.blue:
        return const Color(0xFFB9E2FF);
      case GemType.purple:
        return const Color(0xFFD0B8FF);
      case GemType.green:
        return const Color(0xFFB8F2D0);
      case GemType.yellow:
        return const Color(0xFFFFF0A8);
      case GemType.orange:
        return const Color(0xFFFFD0A6);
    }
  }

  bool get _isRepaintNeeded => true;

  @override
  bool shouldRepaint(covariant _GemPainter oldDelegate) {
    return oldDelegate.gem != gem ||
        oldDelegate.selected != selected ||
        oldDelegate.enabled != enabled ||
        _isRepaintNeeded;
  }
}
