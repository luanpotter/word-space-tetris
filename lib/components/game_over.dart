import 'dart:ui';

import 'package:flame/components/component.dart';

class GameOver extends SpriteComponent {
  // TODO proper game over
  GameOver() : super.square(300, 'logo.png');

  @override
  resize(Size size) {
    x = (size.width - width) / 2;
    y = 64;
  }

  @override
  int priority() => 2;
}
