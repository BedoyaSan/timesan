import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:redux/redux.dart';

import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../util/data_fetch.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return getAuthStatus(context);
  }
}

Widget getAuthStatus(BuildContext context) {
  if (FirebaseAuth.instance.currentUser == null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignInButtonBuilder(
            onPressed: () async {
              Store<AppState> store = StoreProvider.of<AppState>(context);
              store.dispatch(LoadingAction(true));
              await FirebaseAuth.instance.signInAnonymously();
              store.dispatch(SetViewAction('Home'));
              store.dispatch(LoadingAction(false));
            },
            backgroundColor: Colors.cyan,
            text: 'Sign in anonymously',
          ),
          const SizedBox(
            height: 50,
          ),
          SignInButton(
            Buttons.Google,
            onPressed: () async {
              Store<AppState> store = StoreProvider.of<AppState>(context);
              store.dispatch(LoadingAction(true));

              GoogleAuthProvider googleProvider = GoogleAuthProvider();

              await FirebaseAuth.instance.signInWithPopup(googleProvider);

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
                    store.dispatch(LoadGameDataAction(loadData));
                  }
                }
              }

              store.dispatch(SetViewAction('Home'));
              store.dispatch(LoadingAction(false));
            },
          ),
          const SizedBox(
            height: 50,
          ),
          SignInButtonBuilder(
            onPressed: () async {
              Store<AppState> store = StoreProvider.of<AppState>(context);
              store.dispatch(LoadingAction(true));
              store.dispatch(SetViewAction('Home'));
              store.dispatch(LoadingAction(false));
            },
            backgroundColor: const Color.fromARGB(255, 228, 124, 117),
            text: 'Back to main menu',
          ),
        ],
      ),
    );
  }

  if (FirebaseAuth.instance.currentUser!.isAnonymous) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignInButtonBuilder(
            onPressed: () {},
            backgroundColor: Colors.cyan,
            text: FirebaseAuth.instance.currentUser?.displayName ??
                'Anonymous user',
          ),
          const SizedBox(
            height: 50,
          ),
          SignInButtonBuilder(
            onPressed: () async {
              Store<AppState> store = StoreProvider.of<AppState>(context);
              store.dispatch(LoadingAction(true));
              store.dispatch(SetViewAction('Home'));
              store.dispatch(LoadingAction(false));
            },
            backgroundColor: const Color.fromARGB(255, 228, 124, 117),
            text: 'Back to main menu',
          ),
        ],
      ),
    );
  }

  return Container();
}
