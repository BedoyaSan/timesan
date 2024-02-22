import 'package:flutter/material.dart';

class AppState {
  String currentView;
  bool gameInfo;
  bool selectGame;

  int currentGame;


  AppState()
      : currentView = 'Home',
        gameInfo = false,
        selectGame = false,
        currentGame = 0;
}

class AppMainState {
  String currentView;
  bool gameInfo;
  bool selectGame;

  AppMainState(
    this.currentView,
    this.gameInfo,
    this.selectGame,
  );

}

class GameSelectState {
  int currentGame;
  VoidCallback closeSelectState;
  Function setCurrentView;

  GameSelectState(this.currentGame, this.closeSelectState, this.setCurrentView);
}
