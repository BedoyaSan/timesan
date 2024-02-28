import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import '../util/assets.dart';

import '../util/game_item.dart';
import '../util/garden.dart';
import 'components/hex_cell.dart';
import 'components/player.dart';
import 'config.dart';

class TimeSanGame extends FlameGame
    with PanDetector, ScrollDetector, ScaleDetector {
  TimeSanGame(
      {required this.fieldSize,
      required this.gameLevel,
      this.staticGame = false,
      this.gardenData})
      : super();

  late Player player;
  late List<HexCell> grid;

  int fieldSize;
  GameLevelData gameLevel;

  bool staticGame;
  GardenData? gardenData;

  //Sprites
  late SpriteComponent defaultHex;
  late SpriteComponent disabledHex;
  late SpriteComponent hexPlant01;
  late SpriteComponent hexPlant02;
  late SpriteComponent hexPlant03;
  late SpriteComponent waterDrop;
  late SpriteComponent hexBushDefault;

  // late SpriteAnimation hexBush;
  // late SpriteAnimationComponent hexBushAnimationItem;

  late SpriteComponent arrowSwitch;

  // Player movement
  Vector2 initialMovePos = Vector2(0, 0);
  Vector2 finalMovePos = Vector2(0, 0);
  double angleMovement = 0.0;
  bool onMovement = false;
  bool executingAction = false;
  bool toChange = false;
  late Timer hexSwitch;

  //Player initial position
  int playerX = 0;
  int playerY = 0;

  late HexCell currentHex;
  List<HexCell> reactiveHex = [];

  HexCell emptyHex = HexCell(Vector2(0, 0), '')..isDisabled = true;

  List<GardenItem> gardenInventory = [];

  //Grid borders
  List<String> gridBorders = [];
  int topHexX = 0;
  int topHexY = 0;
  int topHexZ = 0;

  //Overlays
  final settingsMenuId = 'SettingsMenu';
  final executeActionId = 'ExecuteActionMenu';
  final informationId = 'InformationMenu';
  final finishMenuId = 'FinishMenu';
  final gameInfoId = 'GameInfo';
  final infoExitId = 'InfoAndExitMenu';
  final welcomeScreenId = 'WelcomeScreen';

  @override
  Color backgroundColor() => const Color.fromARGB(244, 82, 89, 130);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    //Values initialization
    playerX = (fieldSize - 1) * 2;
    playerY = fieldSize - 1;
    topHexY = fieldSize - 1;
    topHexZ = fieldSize - 1;

    // Load images
    defaultHex = SpriteComponent(
      sprite: Sprite(await Flame.images.load(AssetsGame.defaultHexEnabled)),
      size: Vector2(hexMainX * 2, hexMainY * 2),
    );
    disabledHex = SpriteComponent(
      sprite: Sprite(await Flame.images.load(AssetsGame.defaultHexDisabled)),
      size: Vector2(hexMainX * 2, hexMainY * 2),
      paint: Paint()..color = const Color.fromARGB(54, 29, 29, 29),
    );
    hexPlant01 = SpriteComponent(
      sprite: Sprite(await Flame.images.load(AssetsGame.hexPlant01)),
      size: Vector2(hexMainX * 2, hexMainY * 2),
    );
    hexPlant02 = SpriteComponent(
      sprite: Sprite(await Flame.images.load(AssetsGame.hexPlant02)),
      size: Vector2(hexMainX * 2, hexMainY * 2),
    );
    hexPlant03 = SpriteComponent(
      sprite: Sprite(await Flame.images.load(AssetsGame.hexPlant03)),
      size: Vector2(hexMainX * 2, hexMainY * 2),
    );
    waterDrop = SpriteComponent(
      sprite: Sprite(await Flame.images.load(AssetsGame.waterPuddle)),
      size: Vector2(hexMainX * 2, hexMainY * 2),
    );
    arrowSwitch = SpriteComponent(
      sprite: Sprite(await Flame.images.load(AssetsGame.arrowSwitch)),
      size: Vector2(50, 50),
    );
    hexBushDefault = SpriteComponent(
      sprite: Sprite(await Flame.images.load(AssetsGame.hexBush)),
      size: Vector2(hexMainX * 2, hexMainY * 2),
    );

    // Load Animations
    // List<SpriteAnimationFrame> hexBushList = [];
    // hexBushList.add(SpriteAnimationFrame(
    //     Sprite(await Flame.images.load(AssetsGame.hexBush01A)), 100));
    // hexBushList.add(SpriteAnimationFrame(
    //     Sprite(await Flame.images.load(AssetsGame.hexBush01B)), 10));
    // hexBushList.add(SpriteAnimationFrame(
    //     Sprite(await Flame.images.load(AssetsGame.hexBush01C)), 10));
    // hexBush = SpriteAnimation(hexBushList);
    // hexBushAnimationItem = SpriteAnimationComponent(
    //   animation: hexBush,
    //   size: Vector2(hexMainX * 2, hexMainY * 2),
    // );

    // Load Grid Information
    grid = gridBuilder(fieldSize);
    if (!staticGame) {
      grid.shuffle();
      gridBorders = borderGridMap(topHexX, topHexY, topHexZ);
    }

    String centerHexId = '${(fieldSize - 1) * 2}-${fieldSize - 1}';
    currentHex =
        grid.firstWhere((e) => e.idHex == centerHexId, orElse: () => emptyHex);

    // Load Items into grid
    if (staticGame) {
      if (gardenData != null && gardenData!.boardGameItems.isNotEmpty) {
        for (GardenItem item in gardenData!.boardGameItems) {
          if (item.idHex == '') {
            gardenInventory.add(item);
          } else {
            HexCell hexItem = grid.firstWhere((e) => e.idHex == item.idHex,
                orElse: () => emptyHex);
            if (!hexItem.isDisabled) {
              hexItem.countHex = item.countHex;
              hexItem.itemName = item.itemName;
              hexItem.itemNiceName = item.itemNiceName;
              hexItem.isInteractive = item.isInteractive;
              hexItem.isReactive = item.isReactive;

              if (item.isReactive) {
                reactiveHex.add(hexItem);
              }
            }
          }
        }
      }
    } else {
      int aux = 0;
      gameLevel.items.shuffle();
      for (GameItem item in gameLevel.items) {
        while (gridBorders.any((element) =>
            element == grid[aux].idHex ||
            currentHex.idHex == grid[aux].idHex)) {
          aux++;
        }
        grid[aux].itemName = item.itemName;
        grid[aux].isInteractive = item.isInteractive;
        grid[aux].isReactive = item.isReactive;
        grid[aux].itemNiceName = item.itemNiceName;
        aux++;
      }
    }

    world.addAll(grid);

    player = Player()
      ..position = Vector2(0, 0)
      ..width = 50
      ..height = 100
      ..anchor = Anchor.center;
    world.add(player);

    camera.viewfinder.anchor = Anchor.center;
    camera.follow(player);

    overlays.add(settingsMenuId);
    overlays.add(welcomeScreenId);

    debugMode = false;
  }

  void timeMovement(HexCell hexDestination) {
    executingAction = true;

    try {
      if (!staticGame) {
        // Disable a hex of the borders
        HexCell hexToDisable = grid.firstWhere((e) => e.idHex == gridBorders[0],
            orElse: () => emptyHex);
        if (hexToDisable.idHex != hexDestination.idHex) {
          gridBorders.removeAt(0);
          hexToDisable.isDisabled = true;
        }
        if (gridBorders.isEmpty) {
          topHexX += 2;
          topHexZ--;
          gridBorders = borderGridMap(topHexX, topHexY, topHexZ);
          if (gridBorders.isEmpty) {
            overlays.add(finishMenuId);
          }
        }
      }

      // Switch or execute movement
      if (toChange) {
        String idSwitch = currentHex.idHex;
        Vector2 posSwitch = currentHex.gridPosition.clone();
        currentHex.switchHex(
            hexDestination.idHex, hexDestination.gridPosition.clone());
        hexDestination.switchHex(idSwitch, posSwitch);
        toChange = false;

        player.add(
          MoveToEffect(
            currentHex.gridPosition,
            EffectController(duration: 0.5),
          ),
        );
      } else {
        currentHex = hexDestination;
        player.add(MoveToEffect(
          hexDestination.gridPosition,
          EffectController(duration: 0.5),
        ));
      }

      //Interactive Stuff
      for (HexCell hex in reactiveHex) {
        List<String> neighbors = getNeighborHex(hex);

        for (String idHex in neighbors) {
          HexCell hexDestination =
              grid.firstWhere((e) => e.idHex == idHex, orElse: () => emptyHex);

          //TO DO -- Refactor
          if (hex.itemName.contains('HexFlower')) {
            if (!hexDestination.isDisabled &&
                hexDestination.itemName == 'Water') {
              hex.countHex--;
              if (hex.countHex == 0) {
                hex.itemName = 'HexFlower03';
                hex.itemNiceName = 'Medium Hex Flower';
              } else if (hex.countHex <= 2) {
                hex.itemName = 'HexFlower02';
                hex.itemNiceName = 'Hex Flower';
              }
            }
          }
        }

        if (hex.countHex == 0) {
          hex.isReactive = false;
        }
      }

      reactiveHex.removeWhere((hex) => hex.countHex == 0);

      // Overlay Status
      if (currentHex.isInteractive && !overlays.isActive(executeActionId)) {
        overlays.add(executeActionId);
      } else if (!currentHex.isInteractive &&
          overlays.isActive(executeActionId)) {
        overlays.remove(executeActionId);
      }

      if (currentHex.itemName != '' && !overlays.isActive(informationId)) {
        overlays.add(informationId);
      } else if (currentHex.itemName == '' &&
          overlays.isActive(informationId)) {
        overlays.remove(informationId);
      }

      //Check winning condition
      if (!staticGame) {
        int quantity =
            grid.where((hex) => hex.itemName == gameLevel.winningItem).length;
        if (quantity >= gameLevel.winningQuantity) {
          overlays.add(finishMenuId);
        }
      }
    } catch (e) {
      //Something went wrong, one can wonder where
    } finally {
      Timer(const Duration(milliseconds: 500), () {
        executingAction = false;
      });
    }
  }

  // To execute on Action
  void interactWithItem() {
    if (currentHex.itemName == 'HexBush') {
      currentHex.isInteractive = false;
      currentHex.countHex = 4;
      currentHex.itemName = 'HexFlower01';
      currentHex.itemNiceName = 'Small Hex Flower';
      currentHex.isReactive = true;
      reactiveHex.add(currentHex);
      overlays.remove(executeActionId);
    }
  }

  // Movement detection with Mouse or Tactile
  @override
  void onPanStart(DragStartInfo info) {
    initialMovePos = info.eventPosition.global;
  }

  @override
  void onPanCancel() {
    if (hexSwitch.isActive) {
      hexSwitch.cancel();
    }
    toChange = false;
    onMovement = false;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!onMovement) {
      onMovement = true;
      hexSwitch = Timer(const Duration(milliseconds: 1250), () {
        if (onMovement) {
          toChange = true;
        }
      });
    }
    finalMovePos = info.eventPosition.global;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (!executingAction) {
      onMovement = false;
      if (hexSwitch.isActive) {
        hexSwitch.cancel();
      }
      var dx = (finalMovePos.x - initialMovePos.x);
      var dy = (finalMovePos.y - initialMovePos.y);
      dx = (dx == 0) ? 0.01 : dx;
      dy = (dy == 0) ? 0.01 : dy;
      var distance = sqrt(pow(dx, 2) + pow(dy, 2));

      if (distance > 25) {
        angleMovement = calculateAngle(dx, dy);
        int nextX, nextY;
        (nextX, nextY) = getNextHex(angleMovement, playerX, playerY);

        HexCell hexDestination = grid.firstWhere(
            (e) => e.idHex == '$nextX-$nextY',
            orElse: () => emptyHex);

        if (!hexDestination.isDisabled) {
          playerX = nextX;
          playerY = nextY;

          timeMovement(hexDestination);
        }
      } else {
        executingAction = false;
        toChange = false;
      }
    }
  }

  // Zoom in and out Functions -----
  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.05, 3.0);
  }

  static const zoomPerScrollUnit = 0.02;

  @override
  void onScroll(PointerScrollInfo info) {
    camera.viewfinder.zoom -=
        info.scrollDelta.global.y.sign * zoomPerScrollUnit;
    clampZoom();
  }

  late double startZoom;

  @override
  void onScaleStart(info) {
    startZoom = camera.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      camera.viewfinder.zoom = startZoom * currentScale.y;
      clampZoom();
    } else {
      final delta = info.delta.global;
      camera.viewfinder.position.translate(-delta.x, -delta.y);
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

List<HexCell> gridBuilder(int gridHexSize) {
  List<HexCell> grid = [];

  double currentYHex = -(hexMainY * 2 * (gridHexSize - 1));
  double currentXHex = 0;
  int gridLength = (4 * (gridHexSize - 1)) + 1;
  int current = 1;
  int limitReach = 0;

  for (int i = 0; i < gridLength; i++) {
    int yIndex = 0;
    for (int j = 0; j < current; j++) {
      double x = currentXHex + (j * (hexMainX * 3));
      Vector2 position = Vector2(x, currentYHex);
      String hexKey = '$i-${j + (gridHexSize - current) + yIndex}';
      grid.add(HexCell(position, hexKey));

      yIndex++;
    }
    if (current == gridHexSize) {
      limitReach++;
      current--;
      currentXHex += (hexMainX * 3 / 2);
    } else if (limitReach == gridHexSize) {
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

List<String> borderGridMap(int x, int y, int z) {
  List<String> borders = [];
  for (int i = 0; i < z; i++) {
    x++;
    y++;
    borders.add('$x-$y');
  }
  for (int i = 0; i < z; i++) {
    x += 2;
    borders.add('$x-$y');
  }
  for (int i = 0; i < z; i++) {
    x++;
    y--;
    borders.add('$x-$y');
  }
  for (int i = 0; i < z; i++) {
    x--;
    y--;
    borders.add('$x-$y');
  }
  for (int i = 0; i < z; i++) {
    x -= 2;
    borders.add('$x-$y');
  }
  for (int i = 0; i < z; i++) {
    x--;
    y++;
    borders.add('$x-$y');
  }

  borders.shuffle();

  return borders;
}

List<String> getNeighborHex(HexCell hex) {
  List<String> neighbors = [];
  List<String> hexId = hex.idHex.split('-');
  int x = int.parse(hexId[0]);
  int y = int.parse(hexId[1]);
  neighbors.add('${x - 2}-$y');
  neighbors.add('${x - 1}-${y + 1}');
  neighbors.add('${x + 1}-${y + 1}');
  neighbors.add('${x + 2}-$y');
  neighbors.add('${x + 1}-${y - 1}');
  neighbors.add('${x - 1}-${y - 1}');
  return neighbors;
}

GardenData getGardenData(TimeSanGame game) {
  GardenData garden = GardenData();

  for (HexCell hex in game.grid) {
    if (hex.idHex != '') {
      garden.boardGameItems.add(GardenItem(
        hex.itemName,
        hex.itemNiceName,
        hex.idHex,
        hex.countHex,
        hex.isInteractive,
        hex.isReactive,
      ));
    }
  }

  for(GardenItem item in game.gardenInventory) {
    garden.boardGameItems.add(GardenItem(
        item.itemName,
        item.itemNiceName,
        item.idHex,
        item.countHex,
        item.isInteractive,
        item.isReactive,
      ));
  }

  return garden;
}
