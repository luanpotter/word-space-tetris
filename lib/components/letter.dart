import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';

import '../util.dart';
import '../mixins/has_game_ref.dart';

math.Random random = new math.Random();

enum Status {
  ALIVE, COLD, DYING, DEAD
}

class Letter extends SpriteComponent with Resizable, HasGameRef {
  int column;
  String letter;
  Status status = Status.ALIVE;

  double angleSlant;
  double dxTween;

  bool get alive => status == Status.ALIVE;

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
    if (status == Status.DYING) {
      updateDead(t);
      return;
    }
    if (status == Status.COLD) {
      updateCold(t);
      return;
    }
    y += 256 * t;
    int row = gameRef.lastColumns[this.column];
    int myColumnStackSize = row + 1;
    if (y > size.height - myColumnStackSize * height) {
      status = Status.COLD;
      gameRef.lastColumns[this.column]++;
      gameRef.matrix.set(this.column, row, this);
      if (gameRef.lastColumns[this.column] >= ROWS) {
        gameRef.die();
      }
      y = size.height - myColumnStackSize * height;
    }
  }

  void updateCold(double t) {
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
  }

  @override
  void resize(Size size) {
    super.resize(size);
    x = size.width / COLUMNS * column + dxTween;
    width = height = size.width / COLUMNS;
  }

  @override
  int priority() => 2;

  void award() {
    if (status != Status.DYING && status != Status.DEAD) {
      status = Status.DYING;
      int row = ((size.height - (y + height)) / height).round();
      int actualRow = math.min(row, gameRef.lastColumns[this.column]);
      gameRef.lastColumns[this.column] = actualRow;
    }
  }

  void updateDead(double t) {
    // TODO animation
    status = Status.DEAD;
  }

  @override
  bool destroy() => status == Status.DEAD;

  void awake() {
    if (status == Status.COLD) {
      status = Status.ALIVE;
    }
  }
}
