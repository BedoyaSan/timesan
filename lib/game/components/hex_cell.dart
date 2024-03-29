import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../timesan_game.dart';

class HexCell extends PolygonComponent with HasGameReference<TimeSanGame> {
  HexCell(this.gridPosition, this.idHex)
      : super(_getVerticesByCenter(gridPosition));

  Vector2 gridPosition;
  String idHex;
  String itemName = '';
  String itemNiceName = '';
  int countHex = 0;
  bool isDisabled = false;
  bool isInteractive = false;
  bool isReactive = false;

  @override
  void update(double dt) {
    game.corruptedFlower.update(dt);
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
        case 'HexFlower01':
          game.hexPlant01.render(canvas);
          break;
        case 'HexFlower02':
          game.hexPlant02.render(canvas);
          break;
        case 'HexFlower03':
          game.hexPlant03.render(canvas);
          break;
        case 'Water':
          game.waterDrop.render(canvas);
          break;
        case 'HexBush':
          game.hexBushDefault.render(canvas);
          break;
        case 'TrashWater':
          game.trashWater.render(canvas);
        case 'ToxicWater':
          game.toxicWater.render(canvas);
        case 'CorruptedFlower':
          game.corruptedFlower.render(canvas);
      }
    }

    if (countHex > 0) {
      final textPaint = textPainter(romanNumber(countHex));
      textPaint.layout(maxWidth: hexMainX, minWidth: hexMainX);
      textPaint.paint(canvas, const Offset(hexMainX * 1.5, hexMainY));
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

TextPainter textPainter(String value) {
  return TextPainter(
    text: TextSpan(
      text: value,
      style: const TextStyle(
        fontSize: 30,
        color: Colors.red,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
}

String romanNumber(int value) {
  List<int> numbers = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
  List<String> romans = [
    'M',
    'CM',
    'D',
    'CD',
    'C',
    'XC',
    'L',
    'XL',
    'X',
    'IX',
    'V',
    'IV',
    'I',
  ];

  String roman = '';

  for (int i = 0; i < numbers.length; i++) {
    while (value >= numbers[i]) {
      roman += romans[i];
      value -= numbers[i];
    }
  }

  return roman;
}
