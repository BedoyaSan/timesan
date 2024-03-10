import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

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
      double gameHeight = MediaQuery.of(context).size.height;
      return Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            game.interactWithItem();
          },
          mini: gameHeight < 450,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          child: const Icon(Icons.search),
        ),
      );
    },
    // Information button -> Open the information of the current item
    'InformationMenu': (BuildContext context, TimeSanGame game) {
      double gameHeight = MediaQuery.of(context).size.height;

      return Positioned(
        bottom: gameHeight < 450 ? 80 : 100,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            if (game.overlays.isActive(game.gameInfoId)) {
              game.overlays.remove(game.gameInfoId);
            } else {
              game.overlays.add(game.gameInfoId);
            }
          },
          mini: gameHeight < 450,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          child: const Icon(Icons.info),
        ),
      );
    },
    // Settings button -> Shows the menu with information and exit options
    'SettingsMenu': (BuildContext context, TimeSanGame game) {
      double gameHeight = MediaQuery.of(context).size.height;

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
          mini: gameHeight < 450,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          child: const Icon(Icons.settings),
        ),
      );
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
                          : 'You\'ll need to find ${game.gameLevel.winningQuantity} ${game.gameLevel.winningQuantity == 1 ? 'version of' : 'versions of'} ${game.gameLevel.winningItemNiceName} to win this level',
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
                          : 'You\'ll need to find ${game.gameLevel.winningQuantity} ${game.gameLevel.winningQuantity == 1 ? 'version of' : 'versions of'} ${game.gameLevel.winningItemNiceName} to win this level!',
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
                      game.staticGame
                          ? 'Take your time!'
                          : 'Watch your actions!',
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
      double gameHeight = MediaQuery.of(context).size.height;
      return Positioned(
        bottom: 20,
        right: gameHeight < 450 ? 80 : 100,
        child: FloatingActionButton(
          onPressed: () {
            if (game.hasWonGame) {
              game.overlays.add(game.winGameLevelId);
            } else {
              game.overlays.add(game.timeOutId);
            }
          },
          mini: gameHeight < 450,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          child: const Icon(Icons.flag),
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
      double gameHeight = MediaQuery.of(context).size.height;

      return Positioned(
        top: gameHeight < 450 ? 80 : 100,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            if (game.overlays.isActive(game.inventoryGameId)) {
              game.overlays.remove(game.inventoryGameId);
            } else {
              game.overlays.add(game.inventoryGameId);
            }
          },
          mini: gameHeight < 450,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          child: const Icon(Icons.inventory),
        ),
      );
    },
    // Inventory
    'InventoryGame': (BuildContext context, TimeSanGame game) {
      ScrollController controller = ScrollController();

      double gameHeight = MediaQuery.of(context).size.height;
      double gameWidth = MediaQuery.of(context).size.width;

      return GestureDetector(
        onTap: () {
          game.overlays.remove(game.inventoryGameId);
        },
        child: Container(
          height: gameHeight,
          width: gameWidth,
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
                        ? SizedBox(
                            height: gameHeight * 0.5,
                            width: (gameWidth * 0.5) > 250
                                ? 250
                                : (gameWidth * 0.5),
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: controller,
                              shrinkWrap: true,
                              children: _inventoryList(game),
                            ),
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
    // Button to take current item with you
    'TakeItemButton': (BuildContext context, TimeSanGame game) {
      double gameHeight = MediaQuery.of(context).size.height;
      return Positioned(
        top: gameHeight < 450 ? 80 : 100,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            if (game.overlays.isActive(game.takeItemActionId)) {
              game.overlays.remove(game.takeItemActionId);
            } else {
              game.overlays.add(game.takeItemActionId);
            }
            game.takingItem = true;
          },
          mini: gameHeight < 450,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          child: const Icon(Icons.track_changes),
        ),
      );
    },
    // Confirmation on taking an item to the garden
    'TakeItemAction': (BuildContext context, TimeSanGame game) {
      return GestureDetector(
        onTap: () {
          game.overlays.remove(game.takeItemActionId);
          game.takingItem = false;
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
                      'You\'ll receive a copy of ${game.currentHex.itemNiceName} into your garden\nThis will stop time itself',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 24,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        game.overlays.add(game.winGameLevelId);
                        game.overlays.remove(game.takeItemActionId);
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
                            'Take it!',
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    // Container with Game completion message
    'WinGameLevel': (BuildContext context, TimeSanGame game) {
      return GestureDetector(
        onTap: () {
          Store<AppState> store = StoreProvider.of<AppState>(context);

          store.dispatch(LoadingAction(true));
          store.dispatch(CompleteLevelAction(game.gameLevel.levelNumber));
          if (game.takingItem) {
            store.dispatch(
              AddGardenItemAction(
                GardenItem(
                    game.currentHex.itemName,
                    game.currentHex.itemNiceName,
                    '',
                    game.currentHex.countHex,
                    game.currentHex.isInteractive,
                    game.currentHex.isReactive),
              ),
            );
          } else {
            store.dispatch(
              AddGardenItemAction(
                GardenItem(
                  game.gameLevel.winningItem,
                  game.gameLevel.winningItemNiceName,
                ),
              ),
            );
          }
          store.dispatch(SaveCloudGameDataAction());
          store.dispatch(SetViewAction('Home'));
          store.dispatch(ToggleGameSelectAction());
          store.dispatch(LoadingAction(false));
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
                  game.takingItem
                      ? 'A ${game.currentHex.itemNiceName} is going to your garden!\nLet\'s hope time fix the space you\'re leaving here'
                      : 'You\'ve found a ${game.gameLevel.winningItemNiceName}\nThis complete level ${game.gameLevel.levelNumber.toString().padLeft(2, '0')}, congratulations!',
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
    },
    // Container with time out
    'TimeOutGame': (BuildContext context, TimeSanGame game) {
      return GestureDetector(
        onTap: () {
          Store<AppState> store = StoreProvider.of<AppState>(context);
          store.dispatch(LoadingAction(true));
          store.dispatch(SetViewAction('Home'));
          store.dispatch(ToggleGameSelectAction());
          store.dispatch(LoadingAction(false));
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
                  'Time is up, better luck next time!',
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
    },
    // Zoom up!
    'zoomUp': (BuildContext context, TimeSanGame game) {
      return Positioned(
        top: 20,
        left: 20,
        child: FloatingActionButton(
          onPressed: () {
            game.camera.viewfinder.zoom -= -1 * 0.1;
            game.clampZoom();
          },
          mini: true,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          child: const Icon(Icons.zoom_in),
        ),
      );
    },
    // Zoom down!
    'zoomDown': (BuildContext context, TimeSanGame game) {
      return Positioned(
        top: 80,
        left: 20,
        child: FloatingActionButton(
          onPressed: () {
            game.camera.viewfinder.zoom -= 1 * 0.1;
            game.clampZoom();
          },
          mini: true,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          child: const Icon(Icons.zoom_out),
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
          if (item.isInteractive) {
            game.overlays.add(game.executeActionId);
          }

          game.gardenInventory.remove(item);

          game.overlays.remove(game.inventoryGameId);
          game.overlays.add(game.informationId);
        },
        child: Container(
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
