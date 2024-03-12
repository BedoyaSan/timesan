import '../game/components/hex_cell.dart';

Map<String, String> info = {
  'Water': 'A water source, nearby objects may benefit from it',
  'HexBush': 'A bunch of ivy, may find something if inspected',
  'HexFlower01': 'Some sprouts, could grow near a water source',
  'HexFlower02': 'A growing plant',
  'HexFlower03': 'A nice flower, it is said to have special properties',
  'TrashWater' : 'Contaminated water, maybe you can help cleaning it',
  'ToxicWater' : 'Toxic contamination, if there was some way this could be cleaned',
  'CorruptedFlower' : 'Corrupted flower, it has absorbed some nearly corruption source'
};

String gameInfo(HexCell hex) {
  String name = hex.itemName;
  return info[name] ?? '';
}
