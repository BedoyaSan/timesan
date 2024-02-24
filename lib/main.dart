import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'game/overlay_game_menu.dart';
import 'redux/app_state.dart';
import 'redux/reducer.dart';
import 'ui/auth_user.dart';
import 'ui/game_select.dart';
import 'ui/info_screen.dart';
import 'ui/main_menu.dart';
import 'util/game_item.dart';
import 'game/timesan_game.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final store = Store<AppState>(appReducer, initialState: AppState());

  runApp(MainApp(store: store));
}

class MainApp extends StatefulWidget {
  final Store<AppState> store;

  const MainApp({Key? key, required this.store}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
        home: StoreConnector<AppState, AppMainState>(
            converter: (store) => AppMainState(
                  store.state.currentView,
                  store.state.gameInfo,
                  store.state.selectGame,
                ),
            builder: (context, mainState) {
              return Stack(children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1250),
                  // transitionBuilder: (Widget child, Animation<double> animation) =>
                  //     ScaleTransition(scale: animation, child: child),
                  child: appWidget(mainState.currentView),
                ),
                mainState.selectGame ? gameSelect(context, '') : Container(),
                mainState.gameInfo
                    ? infoScreen(
                        context,
                        '- Move around the map an interact with the elements\n'
                        '- Hold when moving for change the next cell object with the current one\n'
                        '- Win by finding a specific object, in the basic games\n'
                        '- Keep playing to unlock the garden!')
                    : Container(),
              ]);
            }),
        theme: ThemeData(
          textTheme: GoogleFonts.robotoCondensedTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

Widget appWidget(String value) {
  switch (value) {
    case 'Home':
      return const MainMenu();
    case 'Garden':
      return gardenInstance();
    case 'Game01':
      return myGameInstance(4);
    case 'Game02':
      return myGameInstance(5);
    case 'Game03':
      return myGameInstance(10);
    case 'Authentication':
      return const AuthUser();

    default:
      return const MainMenu();
  }
}

Widget myGameInstance(int size) {
  return StoreConnector<AppState, int>(
    converter: (store) => store.state.currentGame,
    builder: (context, currentGame) {
      return GameWidget(
        game: TimeSanGame(
          fieldSize: size,
          gameItems: size == 4 ? itemsWorld01 : itemsWorld02,
        ),
        loadingBuilder: (BuildContext context) {
          return const Center(
            child: Text('Loading simulation'),
          );
        },
        overlayBuilderMap: overlayGame(),
      );
    },
  );
}

Widget gardenInstance() {
  return StoreConnector<AppState, int>(
    converter: (store) => store.state.currentGame,
    builder: (context, currentGame) {
      return GameWidget(
        game: TimeSanGame(fieldSize: 6, gameItems: [], staticGame: true),
        loadingBuilder: (BuildContext context) {
          return const Center(
            child: Text('Loading simulation'),
          );
        },
        overlayBuilderMap: overlayGame(),
      );
    },
  );
}
