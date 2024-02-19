class GameItem {
  GameItem(this.itemName);
  
  GameItem.interactive(this.itemName) {
    isInteractive = true;
  }

  late String itemName;
  bool isInteractive = false;
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
