import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';

class Background extends SpriteComponent with Resizable {
  Background() : super.square(1, 'background.png');

  @override
  resize(Size size) {
    width = size.width;
    height = size.height;
  }

  @override
  int priority() => 1;
}
