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
    // Action Button -> Allow interaction with the current item
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
    // Information button -> Open the information of the current item
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
    // Settings button -> Shows the menu with information and exit options
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
            child: const Icon(Icons.settings),
          ));
    },
    // Container of information on how to win and an exit button
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
                      game.staticGame
                          ? 'Time will continue'
                          : 'You\'ll need to find ${game.gameLevel.winningQuantity} ${game.gameLevel.winningQuantity == 1 ? 'version of' : 'versions of'} ${game.gameLevel.winningItem.replaceAll(RegExp(r"\d"), "")} to win this level!',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 24,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StoreConnector<AppState, Function>(
                      converter: (store) {
                        return () {
                          if (game.staticGame) {
                            store.dispatch(LoadingAction(true));
                            store.dispatch(
                                SaveGardenDataAction(getGardenData(game)));
                            store.dispatch(SaveCloudGameDataAction());
                            store.dispatch(SetViewAction('Home'));
                            store.dispatch(LoadingAction(false));
                          } else {
                            store.dispatch(SetViewAction('Home'));
                          }
                        };
                      },
                      builder: (context, callback) {
                        return GestureDetector(
                          onTap: () => callback(),
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
                                game.staticGame
                                    ? 'Save and Exit'
                                    : 'Exit to Main Menu',
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
    // Message to showing at game start
    'WelcomeScreen': (BuildContext context, TimeSanGame game) {
      return GestureDetector(
        onTap: () => game.overlays.remove(game.welcomeScreenId),
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
                      game.staticGame
                          ? 'Welcome to the garden'
                          : 'You\'ll need to find ${game.gameLevel.winningQuantity} ${game.gameLevel.winningQuantity == 1 ? 'version of' : 'versions of'} ${game.gameLevel.winningItem.replaceAll(RegExp(r"\d"), "")} to win this level!',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 24,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      game.staticGame ? 'Enjoy your time!' : 'Take your time!',
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
    },
    // Finish button -> Shows when te winning condition is reached
    'FinishMenu': (BuildContext context, TimeSanGame game) {
      return Positioned(
        bottom: 20,
        right: 100,
        child: StoreConnector<AppState, Function>(
          converter: (store) {
            return () {
              store.dispatch(LoadingAction(true));
              store.dispatch(CompleteLevelAction());
              store.dispatch(
                  AddGardenItemAction(GardenItem('HexFlower03', 'Hex Flower')));
              store.dispatch(SaveCloudGameDataAction());
              store.dispatch(SetViewAction('Home'));
              store.dispatch(LoadingAction(false));
            };
          },
          builder: (context, callback) {
            return FloatingActionButton(
              onPressed: () {
                callback();
              },
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              child: const Icon(Icons.flag),
            );
          },
        ),
      );
    },
    // Container with information of the current item
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
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(
                      height: 20,
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
    },
    // Button to open the Inventory
    'InventoryButton': (BuildContext context, TimeSanGame game) {
      return Positioned(
          top: 100,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              if (game.overlays.isActive(game.inventoryGameId)) {
                game.overlays.remove(game.inventoryGameId);
              } else {
                game.overlays.add(game.inventoryGameId);
              }
            },
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            child: const Icon(Icons.inventory),
          ));
    },
    // Inventory
    'InventoryGame': (BuildContext context, TimeSanGame game) {
      return GestureDetector(
        onTap: () {
          game.overlays.remove(game.inventoryGameId);
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      game.currentHex.itemName == ''
                          ? 'Select the item to be placed'
                          : 'Move to an empty position to place an item',
                      style: GoogleFonts.robotoCondensed(
                        color: game.currentHex.itemName == ''
                            ? Colors.white
                            : Colors.red.shade800,
                        fontSize: 28,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    game.currentHex.itemName == ''
                        ? ListView(
                            shrinkWrap: true,
                            children: _inventoryList(game),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  };
}

List<Widget> _inventoryList(TimeSanGame game) {
  List<Widget> items = [];

  if (game.gardenInventory.isEmpty) {
    items.add(Text(
      'Play some regular levels to get more items',
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      style: GoogleFonts.rubikGlitch(
        color: Colors.white,
        fontSize: 16,
        decoration: TextDecoration.none,
      ),
    ));
  } else {
    for (GardenItem item in game.gardenInventory) {
      items.add(GestureDetector(
        onTap: () {
          game.currentHex.itemName = item.itemName;
          game.currentHex.itemNiceName = item.itemNiceName;
          game.currentHex.countHex = item.countHex;
          game.currentHex.isReactive = item.isReactive;
          game.currentHex.isInteractive = item.isInteractive;

          if (item.isReactive) {
            game.reactiveHex.add(game.currentHex);
          }

          game.gardenInventory.remove(item);

          game.overlays.remove(game.inventoryGameId);
          game.overlays.add(game.informationId);

        },
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
              item.itemNiceName,
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
      ));
    }
  }

  return items;
}
