import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:timesan/game/config.dart';
import 'package:timesan/game/timesan_game.dart';

class HexCell extends PolygonComponent with HasGameReference<TimeSanGame> {
  HexCell(this.gridPosition, this.idHex)
      : super(_getVerticesByCenter(gridPosition));

  Vector2 gridPosition;
  String idHex;
  String itemName = '';
  int countHex = 0;
  bool isDisabled = false;
  bool isInteractive = false;

  @override
  void update(double dt) {
    game.hexBushAnimationItem.update(dt);
  }

  @override
  Future<void> render(Canvas canvas) async {
    if (isDisabled) {
      game.disabledHex.render(canvas);
    } else {
      game.defaultHex.render(canvas);
    }

    if (itemName != '') {
      switch (itemName) {
        case 'HexFlower':
          if (countHex < 2) {
            game.hexPlant01.render(canvas);
          } else if (countHex < 4) {
            game.hexPlant02.render(canvas);
          } else {
            game.hexPlant03.render(canvas);
          }
          break;
        case 'Water':
          game.waterDrop.render(canvas);
          break;
        case 'HexBush':
          game.hexBushAnimationItem.render(canvas);
          break;
      }
    }
  }

  void switchHex(String newId, Vector2 newPos) {
    gridPosition = newPos;
    idHex = newId;
    Vector2 posToUpdate = newPos.clone();
    posToUpdate.x -= hexMainX;
    posToUpdate.y -= hexMainY;
    position = posToUpdate;
  }
}

List<Vector2> _getVerticesByCenter(Vector2 center) {
  List<Vector2> vertices = [];

  vertices.add(Vector2(center.x - hexMainX, center.y));
  vertices.add(Vector2(center.x - (hexMainX / 2), center.y + hexMainY));
  vertices.add(Vector2(center.x + (hexMainX / 2), center.y + hexMainY));
  vertices.add(Vector2(center.x + hexMainX, center.y));
  vertices.add(Vector2(center.x + (hexMainX / 2), center.y - hexMainY));
  vertices.add(Vector2(center.x - (hexMainX / 2), center.y - hexMainY));

  return vertices;
}
