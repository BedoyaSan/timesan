import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:timesan/game/components/hex_cell.dart';

import 'components/player.dart';
import 'components/time_zone.dart';
import 'config.dart';

class TimeSanGame extends FlameGame with PanDetector {
  TimeSanGame()
      : super(
          camera: CameraComponent.withFixedResolution(
              width: gameWidth, height: gameHeight),
        );

  late Player player;
  late List<HexCell> grid;

  double get width => size.x;
  double get height => size.y;

  // Player position utilities
  Vector2 initialMovePos = Vector2(0, 0);
  Vector2 finalMovePos = Vector2(0, 0);
  double angleMovement = 0.0;

  int playerX = (hexGridCount - 1) * 2;
  int playerY = hexGridCount - 1;

  HexCell emptyHex = HexCell(Vector2(0, 0), '')
    ..isDisabled = true
    ..isCurrent = false;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.anchor = Anchor.center;

    world.add(TimeZone());

    grid = gridBuilder();

    world.addAll(grid);

    player = Player()
      ..position = Vector2(0, 0)
      ..width = 50
      ..height = 100
      ..anchor = Anchor.center;

    world.add(player);

    debugMode = true;
  }

  @override
  void onPanDown(DragDownInfo info) {
    initialMovePos = info.eventPosition.global;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    finalMovePos = info.eventPosition.global;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    var dx = (finalMovePos.x - initialMovePos.x);
    var dy = (finalMovePos.y - initialMovePos.y);
    dx = dx == 0 ? 0.01 : dx;
    dy = dy == 0 ? 0.01 : dy;
    var distance = sqrt(pow(dx, 2) + pow(dy, 2));

    if (distance > 25) {
      angleMovement = calculateAngle(dx, dy);
      int nextX, nextY;
      (nextX, nextY) = getNextHex(angleMovement, playerX, playerY);

      HexCell hexDestination = grid.firstWhere(
          (e) => e.idHex == '$nextX-$nextY',
          orElse: () => emptyHex);

      if (hexDestination.isDisabled) {
      } else {
        playerX = nextX;
        playerY = nextY;
        player.movePlayer(hexDestination.gridPosition);
      }
    }
  }
}

double calculateAngle(double dx, double dy) {
  double partialAngle = (atan(dy / dx)) * 180 / pi;
  if (dx > 0 && dy < 0) {
    return partialAngle * -1;
  } else if (dx < 0 && dy < 0) {
    return (180 - partialAngle);
  } else if (dx < 0 && dy > 0) {
    return (180 + (partialAngle * -1));
  } else if (dx > 0 && dy > 0) {
    return (360 - partialAngle);
  }
  return partialAngle;
}

(int, int) getNextHex(double angleMovement, int x, int y) {
  if (angleMovement < 60) {
    x--;
    y++;
  } else if (angleMovement < 120) {
    x -= 2;
  } else if (angleMovement < 180) {
    x--;
    y--;
  } else if (angleMovement < 240) {
    x++;
    y--;
  } else if (angleMovement < 300) {
    x += 2;
  } else if (angleMovement <= 360) {
    x++;
    y++;
  }

  return (x, y);
}

List<HexCell> gridBuilder() {
  List<HexCell> grid = [];

  double currentYHex = -(hexMainY * 2 * (hexGridCount - 1));
  double currentXHex = 0;
  int gridLength = (4 * (hexGridCount - 1)) + 1;
  int current = 1;
  int limitReach = 0;

  for (int i = 0; i < gridLength; i++) {
    int yIndex = 0;
    for (int j = 0; j < current; j++) {
      double x = currentXHex + (j * (hexMainX * 3));
      Vector2 position = Vector2(x, currentYHex);
      String hexKey = '$i-${j + (hexGridCount - current) + yIndex}';

      grid.add(HexCell(position, hexKey));

      yIndex++;
    }
    if (current == hexGridCount) {
      limitReach++;
      current--;
      currentXHex += (hexMainX * 3 / 2);
    } else if (limitReach == hexGridCount) {
      current--;
      currentXHex += (hexMainX * 3 / 2);
    } else {
      current++;
      currentXHex -= (hexMainX * 3 / 2);
    }
    currentYHex += hexMainY;
  }

  return grid;
}
