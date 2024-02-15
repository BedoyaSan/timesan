class GameItem {
  late String itemName;
  bool isInteractive = false;

  GameItem.interactive(this.itemName) {
    isInteractive = true;
  }
  GameItem(this.itemName);
}

List<GameItem> itemsWorld01 = [
  GameItem('Water'),
  GameItem.interactive('HexBush'),
  GameItem.interactive('HexBush'),
  GameItem.interactive('HexBush'),
  GameItem.interactive('HexBush'),
];

List<GameItem> itemsWorld02 = [
  GameItem('Water'),
  GameItem('Water'),
  GameItem.interactive('HexBush'),
  GameItem.interactive('HexBush'),
  GameItem.interactive('HexBush'),
  GameItem.interactive('HexBush'),
  GameItem.interactive('HexBush'),
  GameItem.interactive('HexBush'),
];
