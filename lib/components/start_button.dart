import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import '../mixins/lang_dependent.dart';

class StartButton extends SpriteComponent with LangDependent {
  static const S = 0.5;

  StartButton(String lang) : super.rectangle(S * 580, S * 279, 'start-$lang.png');

  @override
  void resize(Size size) {
    x = (size.width - width) / 2;
    y = size.height - height - 64;
  }

  @override
  int priority() => 2;

  @override
  void didChangeLanguage(String newLang) {
    sprite = new Sprite('start-$newLang.png');
  }
}
