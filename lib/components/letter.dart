import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';

import '../util.dart';
import '../mixins/has_game_ref.dart';

math.Random random = new math.Random();

class Letter extends SpriteComponent with Resizable, HasGameRef {
  int column;
  String letter;
  bool cold = false;

  double angleSlant;
  double dxTween;

  Letter(this.column, this.letter) : super.fromSprite(32.0, 32.0, _sprite(letter)) {
    y = 0;

    angleSlant = math.pi / 180 * (random.nextInt(10) - 5);
    dxTween = (random.nextInt(4) - 2).toDouble();

    angle = angleSlant;
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
      if (angle < 0) {
        angle += 4 * t;
        if (angle > 0) {
          angle = 0;
        }
      } else if (angle > 0) {
        angle -= 4 * t;
        if (angle < 0) {
          angle = 0;
        }
      }

      return;
    }
    y += 256 * t;
    int myColumnStack = gameRef.lastColumns[this.column] + 1;
    if (y > size.height - myColumnStack * height) {
      gameRef.lastColumns[this.column]++;
      y = size.height - myColumnStack * height;
      cold = true;
    }
  }

  @override
  void resize(Size size) {
    super.resize(size);
    x = size.width / COLUMNS * column + dxTween;
    width = height = size.width / COLUMNS;
  }

  @override
  int priority() => 2;
}
