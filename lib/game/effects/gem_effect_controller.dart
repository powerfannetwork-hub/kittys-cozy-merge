import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'gem_effect.dart';

class GemEffectController extends ChangeNotifier {
  final List<GemEffect> _effects = [];

  List<GemEffect> get effects =>
      List.unmodifiable(_effects);

  bool get hasEffects => _effects.isNotEmpty;

  void addEffect(GemEffect effect) {
    _effects.add(effect);
    notifyListeners();
  }

  void addEffects(
    Iterable<GemEffect> effects,
  ) {
    _effects.addAll(effects);
    notifyListeners();
  }

  void removeEffect(GemEffect effect) {
    _effects.remove(effect);
    notifyListeners();
  }

  void clear() {
    if (_effects.isEmpty) {
      return;
    }

    _effects.clear();
    notifyListeners();
  }

  void match({
    required Offset position,
    Color color = Colors.white,
  }) {
    addEffect(
      GemEffect(
        position: position,
        type: GemEffectType.match,
        color: color,
      ),
    );
  }

  void rocketHorizontal({
    required Offset position,
    Color color = Colors.white,
  }) {
    addEffect(
      GemEffect(
        position: position,
        type: GemEffectType.rocketHorizontal,
        color: color,
      ),
    );
  }

  void rocketVertical({
    required Offset position,
    Color color = Colors.white,
  }) {
    addEffect(
      GemEffect(
        position: position,
        type: GemEffectType.rocketVertical,
        color: color,
      ),
    );
  }

  void bomb({
    required Offset position,
    Color color = Colors.white,
  }) {
    addEffect(
      GemEffect(
        position: position,
        type: GemEffectType.bomb,
        color: color,
      ),
    );
  }

  void colorBomb({
    required Offset position,
    Color color = Colors.white,
  }) {
    addEffect(
      GemEffect(
        position: position,
        type: GemEffectType.colorBomb,
        color: color,
      ),
    );
  }

  void sparkle({
    required Offset position,
    Color color = Colors.white,
  }) {
    addEffect(
      GemEffect(
        position: position,
        type: GemEffectType.sparkle,
        color: color,
      ),
    );
  }
}
