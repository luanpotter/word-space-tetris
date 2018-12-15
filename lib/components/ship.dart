import 'package:flame/components/component.dart';

class Ship extends SpriteComponent {
  static const S = 0.2;
  Ship() : super.rectangle(S * 818, S * 443, 'ship.png');

  @override
  int priority() => 2;
}