import 'package:flutter/material.dart';

import '../../game/gems/gem_widget.dart';
import '../obstacles/obstacle_type.dart';
import 'board_position.dart';
import 'game_board.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({
    super.key,
    required this.board,
    this.selectedPosition,
    this.enabled = true,
  });

  final GameBoard board;
  final BoardPosition? selectedPosition;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cells = board.cells;

    if (cells.isEmpty || cells.first.isEmpty) {
      return const SizedBox.shrink();
    }

    final rows = cells.length;
    final columns = cells.first.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        final cellSize = _calculateCellSize(
          width: maxWidth,
          height: maxHeight,
          rows: rows,
          columns: columns,
        );

        final boardWidth = cellSize * columns;
        final boardHeight = cellSize * rows;

        return Center(
          child: SizedBox(
            width: boardWidth,
            height: boardHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BoardPainter(
                      rows: rows,
                      columns: columns,
                    ),
                  ),
                ),
                for (int row = 0; row < rows; row++)
                  for (int column = 0;
                      column < columns;
                      column++)
                    _buildCell(
                      cell: cells[row][column],
                      cellSize: cellSize,
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _calculateCellSize({
    required double width,
    required double height,
    required int rows,
    required int columns,
  }) {
    final widthCellSize = width / columns;
    final heightCellSize = height / rows;

    if (height.isFinite && height > 0) {
      return widthCellSize < heightCellSize
          ? widthCellSize
          : heightCellSize;
    }

    return widthCellSize;
  }

  Widget _buildCell({
    required dynamic cell,
    required double cellSize,
  }) {
    final position = cell.position;
    final gem = cell.gem;

    final selected =
        selectedPosition != null &&
        selectedPosition == position;

    return Positioned(
      left: position.column * cellSize,
      top: position.row * cellSize,
      width: cellSize,
      height: cellSize,
      child: _BoardCellView(
        cell: cell,
        gem: gem,
        cellSize: cellSize,
        selected: selected,
        enabled: enabled,
      ),
    );
  }
}

class _BoardCellView extends StatelessWidget {
  const _BoardCellView({
    required this.cell,
    required this.gem,
    required this.cellSize,
    required this.selected,
    required this.enabled,
  });

  final dynamic cell;
  final dynamic gem;
  final double cellSize;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final hasGem = gem != null;

    return Padding(
      padding: EdgeInsets.all(
        cellSize * 0.035,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            cellSize * 0.18,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF8FD),
              Color(0xFFF2DCEB),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8C5876).withOpacity(0.12),
              blurRadius: cellSize * 0.10,
              offset: Offset(
                0,
                cellSize * 0.045,
              ),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.75),
              blurRadius: cellSize * 0.05,
              offset: Offset(
                -cellSize * 0.02,
                -cellSize * 0.02,
              ),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFFFFFFF).withOpacity(0.72),
            width: cellSize * 0.018,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasGem)
              Center(
                child: GemWidget(
                  gem: gem,
                  size: cellSize * 0.82,
                  selected: selected,
                  enabled: enabled,
                ),
              ),
            if (cell.hasIce)
              IgnorePointer(
                child: CustomPaint(
                  painter: _IcePainter(
                    layers: cell.iceLayers,
                  ),
                ),
              ),
            if (cell.hasBlock)
              const IgnorePointer(
                child: CustomPaint(
                  painter: _BlockPainter(),
                ),
              ),
            if (cell.hasLockedTile)
              const IgnorePointer(
                child: CustomPaint(
                  painter: _LockedTilePainter(),
                ),
              ),
            if (selected)
              IgnorePointer(
                child: CustomPaint(
                  painter: _SelectionPainter(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  const _BoardPainter({
    required this.rows,
    required this.columns,
  });

  final int rows;
  final int columns;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final rect = Offset.zero & size;

    final outerRadius = Radius.circular(
      size.shortestSide * 0.075,
    );

    final shadowPaint = Paint()
      ..color = const Color(0xFF70435F).withOpacity(0.16)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        10,
      );

    final shadowRect = RRect.fromRectAndRadius(
      rect.deflate(size.shortestSide * 0.012),
      outerRadius,
    );

    canvas.drawRRect(
      shadowRect.shift(
        Offset(
          0,
          size.shortestSide * 0.025,
        ),
      ),
      shadowPaint,
    );

    final boardPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFEAF6),
          Color(0xFFEED3E7),
          Color(0xFFDDBBD4),
        ],
      ).createShader(rect);

    final boardRect = RRect.fromRectAndRadius(
      rect,
      outerRadius,
    );

    canvas.drawRRect(
      boardRect,
      boardPaint,
    );

    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.018
      ..color = Colors.white.withOpacity(0.68);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(size.shortestSide * 0.018),
        outerRadius,
      ),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(
    _BoardPainter oldDelegate,
  ) {
    return oldDelegate.rows != rows ||
        oldDelegate.columns != columns;
  }
}

class _SelectionPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.055
      ..color = const Color(0xFFFF78B7)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        2,
      );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(size.shortestSide * 0.10),
        Radius.circular(
          size.shortestSide * 0.14,
        ),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    _SelectionPainter oldDelegate,
  ) {
    return false;
  }
}

class _IcePainter extends CustomPainter {
  const _IcePainter({
    required this.layers,
  });

  final int layers;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final rect = Offset.zero & size;
    final radius = size.shortestSide * 0.14;

    final overlayPaint = Paint()
      ..color = const Color(0xFFBDEFFF).withOpacity(0.34);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(size.shortestSide * 0.06),
        Radius.circular(radius),
      ),
      overlayPaint,
    );

    final crackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.025
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF6CCFEF).withOpacity(0.78);

    final path = Path();

    path.moveTo(
      size.width * 0.25,
      size.height * 0.20,
    );

    path.lineTo(
      size.width * 0.43,
      size.height * 0.43,
    );

    path.lineTo(
      size.width * 0.35,
      size.height * 0.68,
    );

    path.moveTo(
      size.width * 0.43,
      size.height * 0.43,
    );

    path.lineTo(
      size.width * 0.67,
      size.height * 0.30,
    );

    path.moveTo(
      size.width * 0.43,
      size.height * 0.43,
    );

    path.lineTo(
      size.width * 0.74,
      size.height * 0.70,
    );

    canvas.drawPath(
      path,
      crackPaint,
    );

    if (layers > 1) {
      final shinePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.shortestSide * 0.018
        ..color = Colors.white.withOpacity(0.72);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.deflate(size.shortestSide * 0.11),
          Radius.circular(radius),
        ),
        shinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    _IcePainter oldDelegate,
  ) {
    return oldDelegate.layers != layers;
  }
}

class _BlockPainter extends CustomPainter {
  const _BlockPainter();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final rect = Offset.zero & size;

    final blockRect = RRect.fromRectAndRadius(
      rect.deflate(size.shortestSide * 0.07),
      Radius.circular(
        size.shortestSide * 0.12,
      ),
    );

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFB77C72),
          Color(0xFF80514D),
        ],
      ).createShader(rect);

    canvas.drawRRect(
      blockRect,
      paint,
    );

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.028
      ..color = const Color(0xFFE7B0A3).withOpacity(0.68);

    final path = Path();

    path.moveTo(
      size.width * 0.20,
      size.height * 0.32,
    );

    path.lineTo(
      size.width * 0.48,
      size.height * 0.18,
    );

    path.lineTo(
      size.width * 0.78,
      size.height * 0.34,
    );

    path.moveTo(
      size.width * 0.20,
      size.height * 0.66,
    );

    path.lineTo(
      size.width * 0.48,
      size.height * 0.50,
    );

    path.lineTo(
      size.width * 0.78,
      size.height * 0.66,
    );

    canvas.drawPath(
      path,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(
    _BlockPainter oldDelegate,
  ) {
    return false;
  }
}

class _LockedTilePainter extends CustomPainter {
  const _LockedTilePainter();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final rect = Offset.zero & size;

    final overlayPaint = Paint()
      ..color = const Color(0xFF5B4867).withOpacity(0.54);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(size.shortestSide * 0.07),
        Radius.circular(
          size.shortestSide * 0.12,
        ),
      ),
      overlayPaint,
    );

    final lockPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.045
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFE7A8);

    final lockBody = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(
          size.width * 0.50,
          size.height * 0.58,
        ),
        width: size.width * 0.30,
        height: size.height * 0.25,
      ),
      Radius.circular(
        size.shortestSide * 0.045,
      ),
    );

    canvas.drawRRect(
      lockBody,
      lockPaint,
    );

    final shackle = Path();

    shackle.moveTo(
      size.width * 0.39,
      size.height * 0.48,
    );

    shackle.lineTo(
      size.width * 0.39,
      size.height * 0.40,
    );

    shackle.cubicTo(
      size.width * 0.39,
      size.height * 0.25,
      size.width * 0.61,
      size.height * 0.25,
      size.width * 0.61,
      size.height * 0.40,
    );

    shackle.lineTo(
      size.width * 0.61,
      size.height * 0.48,
    );

    canvas.drawPath(
      shackle,
      lockPaint,
    );

    final keyholePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFE7A8);

    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.59,
      ),
      size.shortestSide * 0.035,
      keyholePaint,
    );

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(
          size.width * 0.50,
          size.height * 0.65,
        ),
        width: size.shortestSide * 0.045,
        height: size.shortestSide * 0.10,
      ),
      keyholePaint,
    );
  }

  @override
  bool shouldRepaint(
    _LockedTilePainter oldDelegate,
  ) {
    return false;
  }
}
