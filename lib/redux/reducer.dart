import 'package:redux/redux.dart';

import 'actions.dart';
import 'app_state.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, SetViewAction>(_setView),
  TypedReducer<AppState, ToggleGameSelectAction>(_toggleSelectGame),
  TypedReducer<AppState, ToggleGameInfoAction>(_toggleGameInfo),
  TypedReducer<AppState, CompleteLevelAction>(_completeLevel),
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
