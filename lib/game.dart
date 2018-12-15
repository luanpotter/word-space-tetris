import 'dart:math';

import 'package:flame/components/component.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'util.dart';

import 'mixins/has_game_ref.dart';
import 'components/letter.dart';
import 'components/start_button.dart';
import 'components/logo.dart';
import 'components/background.dart';
import 'components/game_over.dart';

enum Status { MENU, GAME, OVER }

Random random = new Random();

List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');

String randomLetter() {
  return alphabet[random.nextInt(alphabet.length)];
}

class WSTGame extends BaseGame {
  Status status;
  List<int> lastColumns = List.filled(COLUMNS, 0);

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

  double letterInterval = 0.0;

  @override
  void update(double t) {
    super.update(t);
    if (status == Status.GAME) {
      letterInterval += t;
      if (letterInterval > 5) {
        add(new Letter(random.nextInt(COLUMNS), randomLetter()));
        letterInterval = 0.0;
      }
    }
  }

  void input(Position lastPost, int dt) {
    if (status == Status.MENU) {
      goToGame();
    } else if (status == Status.GAME) {
      double halfX = size.width / 2;
      int changeNum = lastPost.x > halfX ? 1 : -1;
      List<Letter> listLetter = components.where((Component component) => component is Letter).toList().cast<Letter>();
      if (listLetter.isEmpty) return;
      if (listLetter.last.cold) return;
      listLetter.last.moveToColumn(changeNum);
    } else if (status == Status.OVER) {
      goToMenu();
    }
  }

  void goToGame() {
    components.clear();
    status = Status.GAME;
    add(new Background());
  }

  void die() {
    status = Status.OVER;
    components.clear();
    add(new Background());
    add(new GameOver());
  }
}
