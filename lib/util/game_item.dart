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
  GameLevelData(this.items, this.winningItem, this.winningQuantity);

  List<GameItem> items;
  String winningItem;
  int winningQuantity;
}

List<GameItem> itemsWorld01 = [
  GameItem('Water', 'Water'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
];
GameLevelData gameWorld01 = GameLevelData(itemsWorld01, 'HexFlower03', 1);

List<GameItem> itemsWorld02 = [
  GameItem('Water', 'Clean Water'),
  GameItem('Water', 'Clean Water'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
  GameItem.interactive('HexBush', 'Bush'),
];
GameLevelData gameWorld02 = GameLevelData(itemsWorld02, 'HexFlower03', 2);
