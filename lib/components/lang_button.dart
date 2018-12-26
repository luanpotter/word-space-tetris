import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import '../mixins/lang_dependent.dart';

class LangButton extends SpriteComponent with LangDependent {
  static const S = 0.5;

  LangButton(String lang) : super.rectangle(S * 120, S * 50, 'lang-$lang.png');

  @override
  void resize(Size size) {
    x = (size.width - width) / 2;
    y = 8.0;
  }

  @override
  int priority() => 2;

  @override
  void didChangeLanguage(String newLang) {
    sprite = new Sprite('lang-$newLang.png');
  }
}
