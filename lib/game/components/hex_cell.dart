import 'dart:math';

import 'package:flame/components.dart';
import 'package:timesan/game/config.dart';
import 'package:timesan/game/timesan_game.dart';

class HexCell extends PolygonComponent with HasAncestor<TimeSanGame> {
  HexCell(this.gridPosition, this.idHex)
      : super(getVerticesByCenter(gridPosition));

  Vector2 gridPosition;
  String idHex;

  bool isCurrent = false;
  bool isDisabled = false;
}

List<Vector2> getVerticesByCenter(Vector2 center) {
  List<Vector2> vertices = [];

  double hexHeight = regularHex ? ((sqrt(3) / 2) * hexMainX) : hexMainY;

  vertices.add(Vector2(center.x - hexMainX, center.y));
  vertices.add(Vector2(center.x - (hexMainX / 2), center.y + hexHeight));
  vertices.add(Vector2(center.x + (hexMainX / 2), center.y + hexHeight));
  vertices.add(Vector2(center.x + hexMainX, center.y));
  vertices.add(Vector2(center.x + (hexMainX / 2), center.y - hexHeight));
  vertices.add(Vector2(center.x - (hexMainX / 2), center.y - hexHeight));

  return vertices;
}
