import 'package:flutter/material.dart';

import 'gem_effect_animation.dart';
import 'gem_effect_controller.dart';

class GemEffectLayer extends StatelessWidget {
  const GemEffectLayer({
    super.key,
    required this.controller,
  });

  final GemEffectController controller;

  @override
  Widget build(BuildContext context) {
    final effects = controller.effects;

    if (effects.isEmpty) {
      return const SizedBox.expand();
    }

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final currentEffects =
              controller.effects;

          if (currentEffects.isEmpty) {
            return const SizedBox.expand();
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              for (final effect in currentEffects)
                GemEffectAnimation(
                  key: ValueKey(
                    effect.id,
                  ),
                  effect: effect,
                  onComplete: () {
                    controller.removeEffect(
                      effect,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
