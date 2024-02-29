import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'game/overlay_game_menu.dart';
import 'redux/actions.dart';
import 'redux/app_state.dart';
import 'ui/about_screen.dart';
import 'util/data_fetch.dart';
import 'redux/reducer.dart';
import 'ui/auth_user.dart';
import 'ui/game_select.dart';
import 'ui/info_screen.dart';
import 'ui/main_menu.dart';
import 'util/game_item.dart';
import 'game/timesan_game.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'util/garden.dart';

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
  void initState() {
    super.initState();

    getInitialData();
  }

  Future<void> getInitialData() async {
    try {
      widget.store.dispatch(LoadingAction(true));
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
      if (FirebaseAuth.instance.currentUser != null) {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          var gameData = await getDataFromUser(userId);
          if (gameData != null && gameData is Map<String, dynamic>) {
            TransferGameData loadData = TransferGameData.fromJson(gameData);
            widget.store.dispatch(LoadGameDataAction(loadData));
          }
        }
      }
    } catch (e) {
      //
      print("There was an error at loading user data");
      print(e);
    } finally {
      widget.store.dispatch(LoadingAction(false));
    }
  }

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
                store.state.about,
                store.state.loading),
            builder: (context, mainState) {
              return Stack(
                children: [
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
                          '- Win by finding a specific object, in the basic games')
                      : Container(),
                  mainState.about
                      ? aboutScreen(
                          context,
                          'Made with Flutter\n'
                          'By San <3')
                      : Container(),
                  mainState.loading
                      ? Container(
                          color: const Color.fromARGB(131, 0, 0, 0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.red.shade800,
                                  strokeAlign: 0.9,
                                  strokeWidth: 10,
                                ),
                                Text(
                                  'Loading data',
                                  style: GoogleFonts.robotoCondensed(
                                    color: Colors.white,
                                    fontSize: 24,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              );
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
          gameLevel: size == 4 ? gameWorld01 : gameWorld02,
        ),
        loadingBuilder: (BuildContext context) {
          return Center(
            child: Text(
              'Loading simulation',
              style: GoogleFonts.robotoCondensed(
                color: Colors.white,
                fontSize: 24,
                decoration: TextDecoration.none,
              ),
            ),
          );
        },
        overlayBuilderMap: overlayGame(),
      );
    },
  );
}

Widget gardenInstance() {
  return StoreConnector<AppState, GardenData>(
    converter: (store) => store.state.gardenGame,
    builder: (context, gardenData) {
      return GameWidget(
        game: TimeSanGame(
          fieldSize: 6,
          gameLevel: GameLevelData([], '', 0),
          staticGame: true,
          gardenData: gardenData,
        ),
        loadingBuilder: (BuildContext context) {
          return Center(
            child: Text(
              'Loading simulation',
              style: GoogleFonts.robotoCondensed(
                color: Colors.white,
                fontSize: 24,
                decoration: TextDecoration.none,
              ),
            ),
          );
        },
        overlayBuilderMap: overlayGame(),
      );
    },
  );
}
