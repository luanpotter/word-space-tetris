import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'game.dart';
import 'word_list.dart';

main() async {
  String startingLang = 'en-us';
  Flame.audio.disableLog();
  Flame.util.fullScreen();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await WordList.init(startingLang);
  WSTGame game = new WSTGame(startingLang);

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (BuildContext ctx) => new Scaffold(body: new WillPopScope(
        onWillPop: () async {
          return game.didPop();
        },
        child: game.widget,
      )),
    },
  ));

  int lastTimestamp;
  Position lastPost;

  Flame.util.addGestureRecognizer(new TapGestureRecognizer()
    ..onTapDown = (TapDownDetails details) {
      lastPost = new Position.fromOffset(details.globalPosition);
      lastTimestamp = new DateTime.now().millisecondsSinceEpoch;
    }
    ..onTapUp = (TapUpDetails details) {
      if (lastTimestamp == null || lastPost == null) {
        return;
      }
      int dt = new DateTime.now().millisecondsSinceEpoch - lastTimestamp;
      if (game != null && game.handlingClick()) {
        game.input(lastPost, dt);
        lastTimestamp = lastPost = null;
      }
    });
}
