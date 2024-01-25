import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../timesan_game.dart';

class TimeZone extends RectangleComponent with HasGameReference<TimeSanGame> {
  TimeZone()
      : super(
          paint: Paint()..color = const Color.fromARGB(255, 156, 156, 210),
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
    anchor = Anchor.center;
  }
}
