import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';

import '../util.dart';
import '../mixins/has_game_ref.dart';

class Letter extends SpriteComponent with Resizable, HasGameRef {
  int column;
  String letter;
  bool cold = false;

  Letter(this.column, this.letter) : super.fromSprite(32.0, 32.0, _sprite(letter)) {
    y = 0;
  }

  static Sprite _sprite(String letter) {
    int x = letter.codeUnitAt(0) - 'a'.codeUnitAt(0);
    return new Sprite('letters.png', x: 85.0 * x, width: 85, height: 85);
  }

  void moveToColumn(int changeCoefficient) {
    column += changeCoefficient;
    column = column.clamp(0, COLUMNS -1);

    this.resize(size);
  }

  @override
  void update(double t) {
    if (cold) {
      return;
    }
    y += 256 * t;
    int myColumnStack = gameRef.lastColumns[this.column] + 1;
    if (y > size.height - myColumnStack*height) {
      gameRef.lastColumns[this.column]++;
      y = size.height - myColumnStack*height;
      cold = true;
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
