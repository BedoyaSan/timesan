import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../util/assets.dart';

Widget gameSelect(BuildContext context, String message) {
  ScrollController controller = ScrollController();

  double gameHeight = MediaQuery.of(context).size.height;
  double gameWidth = MediaQuery.of(context).size.width;
  return StoreConnector<AppState, GameSelectState>(
    converter: (store) {
      return GameSelectState(
        store.state.currentGame,
        () => store.dispatch(ToggleGameSelectAction()),
        (String game) {
          store.dispatch(ToggleGameSelectAction());
          store.dispatch(SetViewAction(game));
        },
        () {
          store.dispatch(ToggleFriendsGardenAction());
        },
      );
    },
    builder: (context, selectGameState) {
      return GestureDetector(
        onTap: selectGameState.closeSelectState,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    color: Colors.black),
                padding: const EdgeInsets.all(25),
                child: SizedBox(
                  height: gameHeight * 0.5,
                  width: (gameWidth * 0.5) > 250 ? 250 : (gameWidth * 0.5),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: controller,
                    shrinkWrap: true,
                    children: [
                      selectGameButton('Level 01',
                          () => selectGameState.setCurrentView('Game01')),
                      selectGameState.currentGame > 0
                          ? selectGameButton('Level 02',
                              () => selectGameState.setCurrentView('Game02'))
                          : Container(),
                      selectGameState.currentGame > 1
                          ? selectGameButton('Level 03',
                              () => selectGameState.setCurrentView('Game03'))
                          : Container(),
                      selectGameButton('Garden',
                          () => selectGameState.setCurrentView('Garden')),
                      selectGameButton('Friend\'s garden',
                          () => selectGameState.toogleFriendsGarden())
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

GestureDetector selectGameButton(String label, VoidCallback selectGame) {
  return GestureDetector(
    onTap: selectGame,
    child: Container(
      width: 200,
      margin: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsUI.hexBorderButton),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          label,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: GoogleFonts.rubikGlitch(
            color: Colors.white,
            fontSize: 16,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    ),
  );
}
