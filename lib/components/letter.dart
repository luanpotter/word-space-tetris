import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';

import '../util.dart';

class Letter extends SpriteComponent with Resizable {
  int column;
  String letter;

  Letter(this.column, this.letter) : super.fromSprite(32.0, 32.0, _sprite(letter)) {
    y = 0;
  }

  static Sprite _sprite(String letter) {
    int x = letter.codeUnitAt(0) - 'a'.codeUnitAt(0);
    return new Sprite('letters.png', x: 85.0 * x, width: 85, height: 85);
  }

  @override
  void update(double t) {
    y += 75 * t;
    if (y > size.height - height) {
      y = size.height - height;
    }
  }

  @override
  void resize(Size size) {
    super.resize(size);
    x = size.width / COLUMNS * column;
    width = height = size.width / COLUMNS;
  }

  @override
  int priority() => 2;
}
