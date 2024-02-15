import 'package:timesan/game/components/hex_cell.dart';

Map<String, String> info = {
  'Water': 'A source of water, living creatures used to drink this',
  'HexBush': 'Bush, may found items in there',
  'HexFlower01': 'A seed of some sort, can grow if near of water sources',
  'HexFlower02': 'A growing plant',
  'HexFlower03': 'A nice flower',
};

String gameInfo(HexCell hex) {
  String name = hex.itemName;
  if (name == 'HexFlower') {
    if (hex.countHex < 2) {
      name += '01';
    } else if (hex.countHex < 4) {
      name += '02';
    } else {
      name += '03';
    }
  }
  return info[name] ?? '';
}
