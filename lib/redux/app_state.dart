import 'package:flutter/material.dart';

import '../util/garden.dart';

class AppState {
  String currentView;
  bool gameInfo;
  bool selectGame;

  int currentGame;
  GardenData gardenGame;
  String userId;
  dynamic userInfo;

  bool loading = false;

  AppState()
      : currentView = 'Home',
        gameInfo = false,
        selectGame = false,
        currentGame = 0,
        userId = '',
        gardenGame = GardenData();
}

class AppMainState {
  String currentView;
  bool gameInfo;
  bool selectGame;
  bool loading;

  AppMainState(
    this.currentView,
    this.gameInfo,
    this.selectGame,
    this.loading
  );
}

class GameSelectState {
  int currentGame;
  VoidCallback closeSelectState;
  Function setCurrentView;

  GameSelectState(this.currentGame, this.closeSelectState, this.setCurrentView);
}

class TransferGameData {
  int currentGame;
  GardenData gardenGame;
  String userId;
  dynamic userInfo;

  TransferGameData()
      : currentGame = 0,
        userId = '',
        userInfo = '',
        gardenGame = GardenData();

  TransferGameData.fromState(AppState data): 
    currentGame = data.currentGame,
    userId = data.userId,
    userInfo = data.userInfo,
    gardenGame = data.gardenGame;

  TransferGameData.load(
      {required this.currentGame,
      required this.userId,
      required this.gardenGame,
      required this.userInfo});

  TransferGameData.fromJson(Map<String, dynamic> data)
      : currentGame = data['currentGame'] as int,
        userId = data['userId'] as String,
        userInfo = data['userInfo'] as String,
        gardenGame = data['gardenGame'] == null ? GardenData() : GardenData.fromJson(data['gardenGame'] as List<dynamic>);

  Map<String, dynamic> toJson() {
    return {
      'currentGame': currentGame,
      'userId': userId,
      'userInfo': userInfo,
      'gardenGame': gardenGame.toJson(),
    };
  }
}