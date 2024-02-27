class GardenData {

  GardenData();
  
  List<GardenItem> boardGameItems = [];

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> json = [];
    for (GardenItem item in boardGameItems) {
      json.add(item.toJson());
    }
    return json;
  }

  GardenData.fromJson(List<Map<String, dynamic>> json)
      : boardGameItems = getFromJson(json);
}

List<GardenItem> getFromJson(List<Map<String, dynamic>> json) {
  List<GardenItem> boardGameItems = [];
  for (Map<String, dynamic> jsonItem in json) {
    boardGameItems.add(GardenItem.fromJson(jsonItem));
  }
  return boardGameItems;
}

class GardenItem {
  GardenItem(this.itemName, this.itemNiceName,
      [this.idHex = '',
      this.countHex = 0,
      this.isInteractive = false,
      this.isReactive = false]);
  String idHex;
  String itemName;
  String itemNiceName;
  int countHex;
  bool isInteractive;
  bool isReactive;

  GardenItem.fromJson(Map<String, dynamic> json)
      : idHex = json['idHex'] == null ? '' : json['idHex'] as String,
        itemName = json['itemName'] as String,
        itemNiceName = json['itemNiceName'] as String,
        countHex = json['countHex'] as int,
        isInteractive = json['isInteractive'] as bool,
        isReactive = json['isReactive'] as bool;

  Map<String, dynamic> toJson() {
    return {
      'idHex': idHex,
      'itemName': itemName,
      'itemNiceName': itemNiceName,
      'countHex': countHex,
      'isInteractive': isInteractive,
      'isReactive': isReactive,
    };
  }
}
