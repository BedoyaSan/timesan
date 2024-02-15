import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timesan/firebase_options.dart';
import 'package:timesan/ui/auth_user.dart';
import 'package:timesan/ui/main_menu.dart';
import 'package:timesan/util/game_Item.dart';
import 'package:timesan/util/game_info.dart';
import 'game/timesan_game.dart';

import 'package:flutter/material.dart';

ValueNotifier<String> currentView = ValueNotifier<String>('Home');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ValueListenableBuilder<String>(
    valueListenable: currentView,
    builder: (context, value, child) => MaterialApp(
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1250),
        // transitionBuilder: (Widget child, Animation<double> animation) =>
        //     ScaleTransition(scale: animation, child: child),
        child: appWidget(currentView.value),
      ),
      theme: ThemeData(
        textTheme: GoogleFonts.rubikGlitchTextTheme(),
      ),
    ),
  ));
}

Widget appWidget(String value) {
  switch (value) {
    case 'Home':
      return const MainMenu();
    case 'Game01':
      return myGameInstance(4);
    case 'Game02':
      return myGameInstance(5);
    case 'Authentication':
      return const AuthUser();

    default:
      return const MainMenu();
  }
}

GameWidget<TimeSanGame> myGameInstance(int size) {
  return GameWidget(
    game: TimeSanGame(
      fieldSize: size,
      gameItems: size == 4 ? itemsWorld01 : itemsWorld02,
    ),
    loadingBuilder: (BuildContext context) {
      return Center(
        child: TextButton(
          child: const Text('Loading game'),
          onPressed: () {},
        ),
      );
    },
    overlayBuilderMap: {
      'SettingsMenu': (BuildContext context, TimeSanGame game) {
        return Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                currentView.value = 'Home';
              },
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              child: const Icon(Icons.settings),
            ));
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
            child: FloatingActionButton(
              onPressed: () {
                currentView.value = 'Home';
              },
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              child: const Icon(Icons.flag),
            ));
      },
      'GameInfo': (BuildContext context, TimeSanGame game) {
        return GestureDetector(
          onTap: () {
            game.overlays.remove(game.gameInfoId);
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    color: Colors.black),
                height: 500,
                width: 700,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      gameInfo(game.currentHex),
                      style: GoogleFonts.rubikGlitch(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    },
  );
}
