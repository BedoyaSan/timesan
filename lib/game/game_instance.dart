import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

import '../redux/app_state.dart';
import '../util/game_item.dart';
import 'overlay_game_menu.dart';
import 'timesan_game.dart';

class GameInstance extends StatelessWidget {
  const GameInstance({required this.level, super.key});
  final int level;

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    return GameWidget(
      game: getGameLevel(level, store.state.currentGame),
      loadingBuilder: (BuildContext context) {
        return Center(
          child: Text(
            'Loading simulation',
            style: GoogleFonts.robotoCondensed(
              color: Colors.white,
              fontSize: 24,
              decoration: TextDecoration.none,
            ),
          ),
        );
      },
      overlayBuilderMap: overlayGame(),
    );
  }

  TimeSanGame getGameLevel(int i, int currentGame) {
    switch (i) {
      case 1:
        return TimeSanGame(
            fieldSize: 4, gameLevel: gameWorld01, currentGame: currentGame);
      case 2:
        return TimeSanGame(
            fieldSize: 5, gameLevel: gameWorld02, currentGame: currentGame);
      case 3:
        return TimeSanGame(
            fieldSize: 5, gameLevel: gameWorld03, currentGame: currentGame);
      default:
        return TimeSanGame(
            fieldSize: 0, gameLevel: gameWorld01, currentGame: currentGame);
    }
  }
}
