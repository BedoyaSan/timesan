import 'package:flutter/material.dart';

import '../util/garden.dart';

class AppState {
  String currentView;
  bool gameInfo;
  bool selectGame;
  bool about;
  bool register;
  bool friendsView;

  int currentGame;
  GardenData gardenGame;
  GardenData friendGarden;
  String userId;
  String userGardenId;

  bool loading = false;

  AppState()
      : currentView = 'Home',
        gameInfo = false,
        selectGame = false,
        about = false,
        register = false,
        currentGame = 0,
        userId = '',
        gardenGame = GardenData(),
        friendGarden = GardenData(),
        userGardenId = '',
        friendsView = false;
}

class AppMainState {
  String currentView;
  bool gameInfo;
  bool selectGame;
  bool about;
  bool loading;
  bool register;
  bool friendsGarden;

  AppMainState(
    this.currentView,
    this.gameInfo,
    this.selectGame,
    this.about,
    this.loading,
    this.register,
    this.friendsGarden
  );
}

class GameSelectState {
  int currentGame;
  VoidCallback closeSelectState;
  Function setCurrentView;
  Function toogleFriendsGarden;

  GameSelectState(this.currentGame, this.closeSelectState, this.setCurrentView, this.toogleFriendsGarden);
}

class TransferGameData {
  int currentGame;
  GardenData gardenGame;
  String userId;
  String userGardenId;

  TransferGameData()
      : currentGame = 0,
        userId = '',
        userGardenId = '',
        gardenGame = GardenData();

  TransferGameData.fromState(AppState data): 
    currentGame = data.currentGame,
    userId = data.userId,
    userGardenId = data.userGardenId,
    gardenGame = data.gardenGame;

  TransferGameData.load(
      {required this.currentGame,
      required this.userId,
      required this.gardenGame,
      required this.userGardenId});

  TransferGameData.fromJson(Map<String, dynamic> data)
      : currentGame = data['currentGame'] as int,
        userId = data['userId'] as String,
        userGardenId = data['userGardenId'] != null ? data['userGardenId'] as String : '',
        gardenGame = data['gardenGame'] == null ? GardenData() : GardenData.fromJson(data['gardenGame'] as List<dynamic>);

  Map<String, dynamic> toJson() {
    return {
      'currentGame': currentGame,
      'userId': userId,
      'userGardenId': userGardenId,
      'gardenGame': gardenGame.toJson(),
    };
  }
}