import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';

class Logo extends SpriteComponent with Resizable {
  Logo() : super.square(300, 'logo.png');

  @override
  resize(Size size) {
    x = (size.width - width) / 2;
    y = 64;
  }

  @override
  int priority() => 2;
}
