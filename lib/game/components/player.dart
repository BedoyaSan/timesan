import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../timesan_game.dart';

class Player extends PositionComponent with HasGameReference<TimeSanGame> {
  @override
  void update(double dt) {
    game.botLeftAnimation.update(dt);
    game.botRightAnimation.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (game.angleMovement > 90 && game.angleMovement < 270) {
      if (game.toChange) {
        game.botLeftSwitch.render(canvas);
      } else if (game.executingAction) {
        game.botLeftAnimation.render(canvas);
      } else {
        game.botLeft.render(canvas);
      }
    } else {
      if (game.toChange) {
        game.botRightSwitch.render(canvas);
      } else if (game.executingAction) {
        game.botRightAnimation.render(canvas);
      } else {
        game.botRight.render(canvas);
      }
    }
  }
}
