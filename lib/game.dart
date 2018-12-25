import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart' as material;

import 'components/background.dart';
import 'components/game_over.dart';
import 'components/letter.dart';
import 'components/logo.dart';
import 'components/start_button.dart';
import 'mixins/has_game_ref.dart';
import 'matrix.dart';
import 'word_list.dart';
import 'util.dart';

enum Status { MENU, GAME, PAUSED, DYING, OVER }

Random random = new Random();

String randomLetter() => WordList.nextLetter(random.nextDouble());

class WSTGame extends BaseGame {
  Status status;
  Matrix matrix;
  List<int> lastColumns;
  double letterInterval;

  WSTGame() {
    goToMenu();
  }

  void goToMenu() {
    status = Status.MENU;

    add(new Background());
    add(new Logo());
    add(new StartButton());
  }

  bool handlingClick() => true;

  @override
  void add(Component c) {
    if (c is HasGameRef) {
      (c as HasGameRef).gameRef = this;
    }
    super.add(c);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (status == Status.GAME || status == Status.PAUSED) {
      drawTopLine(canvas);
    }
    if (status == Status.PAUSED) {
      // TODO render pause button
    }
  }

  void drawTopLine(Canvas canvas) {
    double maxY = size.height - size.width / COLUMNS * ROWS;
    Paint paint = new Paint()..color = material.Colors.black;
    canvas.drawLine(new Offset(0, maxY), new Offset(size.width, maxY), paint);
  }

  @override
  void update(double t) {
    if (status == Status.DYING) {
      // TODO animation?
      components.clear();
      add(new Background());
      add(new GameOver());
      status = Status.OVER;
      return;
    }
    if (status == Status.PAUSED) {
      return;
    }
    super.update(t);
    if (status == Status.GAME) {
      letterInterval += t;
      if (letterInterval > 3) {
        add(new Letter(random.nextInt(COLUMNS), randomLetter()));
        letterInterval = 0.0;
      }
    }
  }

  void input(Position lastPost, int dt) {
    if (status == Status.PAUSED) {
      status = Status.GAME;
    } else if (status == Status.MENU) {
      goToGame();
    } else if (status == Status.GAME) {
      double halfX = size.width / 2;
      int changeNum = lastPost.x > halfX ? 1 : -1;
      List<Letter> listLetter = components.where((Component component) => component is Letter).toList().cast<Letter>();
      if (listLetter.isEmpty) return;
      if (!listLetter.last.alive) return;
      listLetter.last.moveToColumn(changeNum);
    } else if (status == Status.OVER) {
      goToMenu();
    }
  }

  void goToGame() {
    components.clear();
    status = Status.GAME;
    matrix = new Matrix();
    lastColumns = List.filled(COLUMNS, 0);
    letterInterval = 2.0;
    add(new Background());
  }

  void die() {
    status = Status.DYING;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      if (status == Status.GAME) {
        status = Status.PAUSED;
      }
    }
  }

  didPop() {
    if (status == Status.MENU) {
      return true;
    }
    status = Status.MENU;
    return false;
  }
}
