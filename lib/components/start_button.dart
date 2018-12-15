import 'dart:ui';

import 'package:flame/components/component.dart';

class StartButton extends SpriteComponent {

  static const S = 0.5;
  StartButton() : super.rectangle(S * 580, S * 279, 'start.png');

  @override
  void resize(Size size) {
    x = (size.width - width) / 2;
    y = size.height - height - 64;
  }

  @override
  int priority() => 2;
}