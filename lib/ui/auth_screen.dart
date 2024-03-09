import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:redux/redux.dart';

import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../util/data_fetch.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous user',
  );
  String newNameValue =
      FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous user';

  @override
  void initState() {
    _nameController.addListener(() {
      setState(() {
        newNameValue = _nameController.value.text;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthValue = MediaQuery.of(context).size.width;
    if (FirebaseAuth.instance.currentUser == null) {
      return Material(
        child: Center(
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
                height: 15,
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
                height: 15,
              ),
              SignInButtonBuilder(
                onPressed: () async {
                  Store<AppState> store = StoreProvider.of<AppState>(context);
                  store.dispatch(SetViewAction('Home'));
                },
                backgroundColor: const Color.fromARGB(255, 228, 124, 117),
                text: 'Back to main menu',
              ),
            ],
          ),
        ),
      );
    }

    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: widthValue * 0.2,
                right: widthValue * 0.2,
              ),
              child: TextFormField(
                controller: _nameController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  iconColor: Color.fromARGB(255, 46, 86, 155),
                  suffixIcon: Icon(Icons.edit),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            (newNameValue != '' &&
                    newNameValue !=
                        FirebaseAuth.instance.currentUser?.displayName &&
                    (FirebaseAuth.instance.currentUser!.isAnonymous &&
                        newNameValue != 'Anonymous user'))
                ? SignInButtonBuilder(
                    backgroundColor: Colors.cyan,
                    onPressed: () async {
                      Store<AppState> store =
                          StoreProvider.of<AppState>(context);
                      store.dispatch(LoadingAction(true));
                      await FirebaseAuth.instance.currentUser
                          ?.updateDisplayName(newNameValue);
                      await FirebaseAuth.instance.currentUser?.reload();
                      setState(() {});
                      store.dispatch(LoadingAction(false));
                    },
                    text: 'Update name')
                : const SizedBox(
                    height: 25,
                  ),
            const SizedBox(
              height: 15,
            ),
            SignInButtonBuilder(
              onPressed: () {
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
      ),
    );
  }
}
