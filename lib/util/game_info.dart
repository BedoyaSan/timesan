import '../game/components/hex_cell.dart';

Map<String, String> info = {
  'Water': 'A water source, nearby objects may benefit from it',
  'HexBush': 'A bunch of ivy, may find something if inspected',
  'HexFlower01': 'Some sprouts, could grow near a water source',
  'HexFlower02': 'A growing plant',
  'HexFlower03': 'A nice flower',
};

String gameInfo(HexCell hex) {
  String name = hex.itemName;
  if (name == 'HexFlower') {
    if (hex.countHex > 2) {
      name += '01';
    } else if (hex.countHex > 0) {
      name += '02';
    } else {
      name += '03';
    }
  }
  return info[name] ?? '';
}
