import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../util/game_info.dart';
import 'timesan_game.dart';

Map<String, Widget Function(BuildContext, TimeSanGame)> overlayGame() {
  return {
    'SettingsMenu': (BuildContext context, TimeSanGame game) {
      return Positioned(
        top: 20,
        right: 20,
        child: StoreConnector<AppState, Function>(
          converter: (store) {
            return (String view) => store.dispatch(SetViewAction(view));
          },
          builder: (context, callback) {
            return FloatingActionButton(
              onPressed: () {
                callback('Home');
              },
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              child: const Icon(Icons.exit_to_app),
            );
          },
        ),
      );
    },
    'ExecuteActionMenu': (BuildContext context, TimeSanGame game) {
      return Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              game.interactWithItem();
            },
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            child: const Icon(Icons.search),
          ));
    },
    'InformationMenu': (BuildContext context, TimeSanGame game) {
      return Positioned(
          bottom: 100,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              if (game.overlays.isActive(game.gameInfoId)) {
                game.overlays.remove(game.gameInfoId);
              } else {
                game.overlays.add(game.gameInfoId);
              }
            },
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            child: const Icon(Icons.info),
          ));
    },
    'FinishMenu': (BuildContext context, TimeSanGame game) {
      return Positioned(
        bottom: 20, 
        right: 100,
        child: StoreConnector<AppState, Function>(
          converter: (store) {
            return (String view) {
              store.dispatch(CompleteLevelAction());
              store.dispatch(SetViewAction(view));
            };
          },
          builder: (context, callback) {
            return FloatingActionButton(
              onPressed: () {
                callback('Home');
              },
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              child: const Icon(Icons.flag),
            );
          },
        ),
      );
    },
    'GameInfo': (BuildContext context, TimeSanGame game) {
      return GestureDetector(
        onTap: () {
          game.overlays.remove(game.gameInfoId);
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    color: Colors.black),
                padding: const EdgeInsets.all(25),
                child: Text(
                  gameInfo(game.currentHex),
                  style: GoogleFonts.robotoCondensed(
                    color: Colors.white,
                    fontSize: 24,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  };
}
