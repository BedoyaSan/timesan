import '../util/garden.dart';
import 'app_state.dart';

class SetViewAction {
  final String view;

  SetViewAction(this.view);
}

class ToggleGameInfoAction {}
class ToggleGameSelectAction {}
class ToggleGameAboutAction {}
class ToggleGameRegisterAction {}
class ToggleFriendsGardenAction {}

class CompleteLevelAction {
  final int levelNumber;

  CompleteLevelAction(this.levelNumber);
}

class LoadGameDataAction {
  final TransferGameData gameData;

  LoadGameDataAction(this.gameData);
}

class LoadingAction {
  final bool loading;

  LoadingAction(this.loading);
}

class AddGardenItemAction {
  final GardenItem item;

  AddGardenItemAction(this.item);
}

class SaveGardenDataAction {
  final GardenData garden;

  SaveGardenDataAction(this.garden);
}

class SaveCloudGameDataAction {}

class SaveGardenIdAction {
  final String gardenId;
  SaveGardenIdAction(this.gardenId);
}

class SaveFriendGardenAction {
  GardenData garden;
  SaveFriendGardenAction(this.garden);
}