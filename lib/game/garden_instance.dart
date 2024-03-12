import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

import '../redux/app_state.dart';
import '../util/game_item.dart';
import '../util/garden.dart';
import 'overlay_game_menu.dart';
import 'timesan_game.dart';

class GardenInstance extends StatelessWidget {
  const GardenInstance({required this.friend, super.key});
  final bool friend;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GardenData>(
      converter: (store) =>
          friend ? store.state.friendGarden : store.state.gardenGame,
      builder: (context, gardenData) {
        return GameWidget(
          game: TimeSanGame(
              fieldSize: 6,
              gameLevel: GameLevelData([], 0, '', '', 0),
              staticGame: true,
              gardenData: gardenData,
              currentGame: 0,
              friendsGame: friend),
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
      },
    );
  }
}
