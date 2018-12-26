import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart' show TextPainter;

class GameOver extends SpriteComponent {
  static const Color WHITE = Color(0xFFFFFFFF);

  // TODO proper game over
  GameOver() : super.square(300, 'logo.png');

  Size screenSize;

  void _add(Canvas canvas, String str, double y) {
    TextPainter text = Flame.util.text(str, fontSize: 14.0, color: WHITE);
    text.paint(canvas, new Offset((screenSize.width - text.width) / 2, y));
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    super.render(canvas);
    canvas.restore();

    TextPainter text1 = Flame.util.text('Game Over!', fontSize: 42.0, color: WHITE);
    text1.paint(canvas, new Offset((screenSize.width - text1.width) / 2, 360.0));

    double y = 420.0;
    _add(canvas, 'Game created by Anne and impl. with love by luanpotter.', y);
    _add(canvas, 'It was developed mostly during 2018\'s Dextra Hackathon.', y + 20);
    _add(canvas, 'This is Open Source and Beta, so expect more to come.', y + 40);
    _add(canvas, 'Thank you so much for playing!', y + 60);
    _add(canvas, 'Feel free to open issues and PRs', y + 80);
    _add(canvas, 'https://github.com/luanpotter/word-space-tetris', y + 100);
  }

  @override
  void resize(Size size) {
    this.screenSize = size;
    x = (size.width - width) / 2;
    y = 64;
  }

  @override
  int priority() => 2;
}
