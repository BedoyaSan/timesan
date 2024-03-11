class GameItem {
  GameItem(this.itemName, this.itemNiceName);

  GameItem.interactive(this.itemName, this.itemNiceName) {
    isInteractive = true;
  }

  late String itemName;
  late String itemNiceName;
  bool isInteractive = false;
  bool isReactive = false;
}

class GameLevelData {
  GameLevelData(this.items, this.levelNumber, this.winningItem,
      this.winningItemNiceName, this.winningQuantity);

  List<GameItem> items;
  int levelNumber;
  String winningItem;
  String winningItemNiceName;
  int winningQuantity;
}

List<GameItem> itemsWorld01 = [
  GameItem('Water', 'Water'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
];
GameLevelData gameWorld01 =
    GameLevelData(itemsWorld01, 1, 'HexFlower03', 'Hex Flower', 1);

List<GameItem> itemsWorld02 = [
  GameItem.interactive('TrashWater', 'Contaminated Water'),
  GameItem.interactive('TrashWater', 'Contaminated Water'),
  GameItem.interactive('TrashWater', 'Contaminated Water'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
];
GameLevelData gameWorld02 =
    GameLevelData(itemsWorld02, 2, 'HexFlower03', 'Hex Flower', 2);

List<GameItem> itemsWorld03 = [
  GameItem.interactive('TrashWater', 'Contaminated Water'),
  GameItem.interactive('TrashWater', 'Contaminated Water'),
  GameItem.interactive('TrashWater', 'Contaminated Water'),
  GameItem.interactive('ToxicWater', 'Toxic Water'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
];
GameLevelData gameWorld03 =
    GameLevelData(itemsWorld03, 3, 'HexFlower03', 'Hex Flower', 2);
