import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../util/assets.dart';
import '../util/game_info.dart';
import '../util/garden.dart';
import 'timesan_game.dart';

Map<String, Widget Function(BuildContext, TimeSanGame)> overlayGame() {
  return {
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
    'SettingsMenu': (BuildContext context, TimeSanGame game) {
      return Positioned(
          top: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              if (game.overlays.isActive(game.infoExitId)) {
                game.overlays.remove(game.infoExitId);
              } else {
                game.overlays.add(game.infoExitId);
              }
            },
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            child: const Icon(Icons.info),
          ));
    },
    'InfoAndExitMenu': (BuildContext context, TimeSanGame game) {
      return GestureDetector(
        onTap: () => game.overlays.remove(game.infoExitId),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You\'ll need to find ${game.gameLevel.winningQuantity} ${game.gameLevel.winningQuantity == 1 ? 'version of' : 'versions of'} ${game.gameLevel.winningItem.replaceAll(RegExp(r"\d"), "")} to win this level!',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 24,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    StoreConnector<AppState, Function>(
                      converter: (store) {
                        return (String view) {
                          store.dispatch(SetViewAction(view));
                        };
                      },
                      builder: (context, callback) {
                        return GestureDetector(
                          onTap: () => callback('Home'),
                          child: Container(
                            width: 200,
                            margin: const EdgeInsets.only(top: 16),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(AssetsUI.hexBorderButton),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Go back to main menu',
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.ltr,
                                style: GoogleFonts.rubikGlitch(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    'FinishMenu': (BuildContext context, TimeSanGame game) {
      return Positioned(
        bottom: 20,
        right: 100,
        child: StoreConnector<AppState, Function>(
          converter: (store) {
            return (String view) {
              store.dispatch(CompleteLevelAction());
              store.dispatch(AddGardenItemAction(GardenItem('HexFlower03', 'Hex Flower')));
              store.dispatch(SaveCloudGameDataAction());
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      game.currentHex.itemNiceName,
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 28,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      gameInfo(game.currentHex),
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 24,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  };
}
