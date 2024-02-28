import 'package:redux/redux.dart';

import '../util/data_fetch.dart';
import 'actions.dart';
import 'app_state.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, SetViewAction>(_setView),
  TypedReducer<AppState, ToggleGameSelectAction>(_toggleSelectGame),
  TypedReducer<AppState, ToggleGameInfoAction>(_toggleGameInfo),
  TypedReducer<AppState, CompleteLevelAction>(_completeLevel),
  TypedReducer<AppState, LoadGameDataAction>(_loadGameData),
  TypedReducer<AppState, LoadingAction>(_loading),
  TypedReducer<AppState, AddGardenItemAction>(_addGardenItem),
  TypedReducer<AppState, SaveCloudGameDataAction>(_saveCloudGameData),
]);

AppState _setView(AppState state, SetViewAction action) {
  state.currentView = action.view;
  return state;
}

AppState _toggleSelectGame(AppState state, ToggleGameSelectAction action) {
  state.selectGame = !state.selectGame;
  return state;
}

AppState _toggleGameInfo(AppState state, ToggleGameInfoAction action) {
  state.gameInfo = !state.gameInfo;
  return state;
}

AppState _completeLevel(AppState state, CompleteLevelAction action) {
  state.currentGame = state.currentGame + 1;
  return state;
}

AppState _loadGameData(AppState state, LoadGameDataAction action) {
  state.userId = action.gameData.userId;
  state.userInfo = action.gameData.userInfo;
  state.gardenGame = action.gameData.gardenGame;
  return state;
}

AppState _loading(AppState state, LoadingAction action) {
  state.loading = action.loading;

  return state;
}

AppState _addGardenItem(AppState state, AddGardenItemAction action) {
  state.gardenGame.boardGameItems.add(action.item);

  return state;
}

AppState _saveCloudGameData(AppState state, SaveCloudGameDataAction action) {
  print("We have");
  print(state.userId);
  print(state.currentView);
  saveDataFromUser(TransferGameData.fromState(state), state.userId);

  return state;
}
