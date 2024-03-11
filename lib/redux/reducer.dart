import 'package:redux/redux.dart';

import '../util/data_fetch.dart';
import 'actions.dart';
import 'app_state.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, SetViewAction>(_setView),
  TypedReducer<AppState, ToggleGameSelectAction>(_toggleSelectGame),
  TypedReducer<AppState, ToggleGameInfoAction>(_toggleGameInfo),
  TypedReducer<AppState, ToggleGameAboutAction>(_toggleGameAbout),
  TypedReducer<AppState, ToggleGameRegisterAction>(_toggleGameRegister),
  TypedReducer<AppState, CompleteLevelAction>(_completeLevel),
  TypedReducer<AppState, LoadGameDataAction>(_loadGameData),
  TypedReducer<AppState, LoadingAction>(_loading),
  TypedReducer<AppState, AddGardenItemAction>(_addGardenItem),
  TypedReducer<AppState, SaveGardenDataAction>(_saveGardenData),
  TypedReducer<AppState, SaveCloudGameDataAction>(_saveCloudGameData),
  TypedReducer<AppState, ToggleFriendsGardenAction>(_toggleFriendsGarden),
  TypedReducer<AppState, SaveGardenIdAction>(_saveGardenId),
  TypedReducer<AppState, SaveFriendGardenAction>(_saveFriendGarden),
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

AppState _toggleGameAbout(AppState state, ToggleGameAboutAction action) {
  state.about = !state.about;
  return state;
}

AppState _toggleGameRegister(AppState state, ToggleGameRegisterAction action) {
  state.register = !state.register;
  return state;
}

AppState _toggleFriendsGarden(
    AppState state, ToggleFriendsGardenAction action) {
  state.friendsView = !state.friendsView;
  return state;
}

AppState _completeLevel(AppState state, CompleteLevelAction action) {
  if (action.levelNumber > state.currentGame) {
    state.currentGame = state.currentGame + 1;
  }
  return state;
}

AppState _loadGameData(AppState state, LoadGameDataAction action) {
  state.userId = action.gameData.userId;
  state.userGardenId = action.gameData.userGardenId;
  state.gardenGame = action.gameData.gardenGame;
  state.currentGame = action.gameData.currentGame;

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

AppState _saveGardenData(AppState state, SaveGardenDataAction action) {
  state.gardenGame = action.garden;

  return state;
}

AppState _saveCloudGameData(AppState state, SaveCloudGameDataAction action) {
  saveDataFromUser(TransferGameData.fromState(state), state.userId);

  return state;
}

AppState _saveGardenId(AppState state, SaveGardenIdAction action) {
  state.userGardenId = action.gardenId;

  return state;
}

AppState _saveFriendGarden(AppState state, SaveFriendGardenAction action) {
  state.friendGarden = action.garden;
  return state;
}
