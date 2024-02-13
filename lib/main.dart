import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timesan/ui/main_menu.dart';
import 'game/timesan_game.dart';

import 'package:flutter/material.dart';

ValueNotifier<String> currentView = ValueNotifier<String>('Home');

void main() {
  runApp(ValueListenableBuilder<String>(
    valueListenable: currentView,
    builder: (context, value, child) => MaterialApp(
      home: AnimatedSwitcher(
        duration: const Duration(seconds: 2),
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

    default:
      return const MainMenu();
  }
}

GameWidget<TimeSanGame> myGameInstance(int size) {
  return GameWidget(
    game: TimeSanGame(
      fieldSize: size,
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
              onPressed: () {},
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
    },
  );
}
