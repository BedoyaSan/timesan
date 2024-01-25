import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'game/timesan_game.dart';

void main() {
  final TimeSanGame game = TimeSanGame();
  runApp(GameWidget(game: game));
}
