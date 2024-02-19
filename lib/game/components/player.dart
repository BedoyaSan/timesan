import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../timesan_game.dart';

class Player extends PositionComponent with HasGameReference<TimeSanGame> {
  static final _paint = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
    if (game.toChange) {
      game.arrowSwitch.render(canvas);
    }
  }
}
