import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'game/game_instance.dart';
import 'game/garden_instance.dart';
import 'redux/actions.dart';
import 'redux/app_state.dart';
import 'ui/about_screen.dart';
import 'ui/auth_screen.dart';
import 'ui/friends_garden.dart';
import 'ui/register.dart';
import 'util/data_fetch.dart';
import 'redux/reducer.dart';
import 'ui/game_select.dart';
import 'ui/info_screen.dart';
import 'ui/main_menu.dart';
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
  void initState() {
    super.initState();

    getInitialData();
  }

  Future<void> getInitialData() async {
    try {
      widget.store.dispatch(LoadingAction(true));
      if (FirebaseAuth.instance.currentUser == null) {
        widget.store.dispatch(ToggleGameRegisterAction());
      } else {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          var gameData = await getDataFromUser(userId);
          if (gameData != null) {
            TransferGameData? loadData;
            if (gameData is Map<String, dynamic>) {
              loadData = TransferGameData.fromJson(gameData);
            } else if (gameData is TransferGameData) {
              loadData = gameData;
            }
            if (loadData != null) {
              widget.store.dispatch(LoadGameDataAction(loadData));
            }
          }
        }
      }
    } catch (e) {
      // Something went wrong on retrieving user data!
    } finally {
      setState(() {
        FirebaseAuth.instance.currentUser?.reload();
      });
      widget.store.dispatch(LoadingAction(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: PopScope(
        canPop: false,
        child: MaterialApp(
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown
            },
          ),
          home: StoreConnector<AppState, AppMainState>(
              converter: (store) => AppMainState(
                  store.state.currentView,
                  store.state.gameInfo,
                  store.state.selectGame,
                  store.state.about,
                  store.state.loading,
                  store.state.register,
                  store.state.friendsView),
              builder: (context, mainState) {
                return Stack(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: appWidget(mainState.currentView),
                    ),
                    mainState.selectGame
                        ? gameSelect(context, '')
                        : Container(),
                    mainState.gameInfo
                        ? infoScreen(
                            context,
                            '- Move around the map an interact with the elements\n'
                            '- Hold when moving for change the next cell object with the current one\n'
                            '- Get items by winning levels or replaying levels, then use them in your own garden!')
                        : Container(),
                    mainState.about
                        ? aboutScreen(
                            context,
                            'Made with Flutter\n'
                            'By San <3')
                        : Container(),
                    mainState.register ? register(context) : Container(),
                    mainState.friendsGarden
                        ? const FriendsGarden()
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
      ),
    );
  }
}

Widget appWidget(String value) {
  switch (value) {
    case 'Home':
      return const MainMenu();
    case 'Garden':
      return const GardenInstance(friend: false);
    case 'FriendsGarden':
      return const GardenInstance(friend: true);
    case 'Game01':
      return const GameInstance(level: 1);
    case 'Game02':
      return const GameInstance(level: 2);
    case 'Game03':
      return const GameInstance(level: 3);
    case 'Authentication':
      return const AuthScreen();

    default:
      return const MainMenu();
  }
}
