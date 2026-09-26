import 'package:flutter/material.dart';

class EffectStack extends StatelessWidget {
  const EffectStack({
    super.key,
    required this.child,
    this.layers = const <Widget>[],
  });

  final Widget child;
  final List<Widget> layers;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        child,
        ...layers,
      ],
    );
  }
}
