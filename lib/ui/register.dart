import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../util/assets.dart';

Widget register(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: Colors.black.withOpacity(0.7),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              color: Colors.black),
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login to a Google account, to keep or recover your progress data',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.white,
                  fontSize: 24,
                  decoration: TextDecoration.none,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Store<AppState> store = StoreProvider.of<AppState>(context);
                  store.dispatch(ToggleGameRegisterAction());
                  store.dispatch(SetViewAction('Authentication'));
                },
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
                      'Log in / Register',
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
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Or feel free to start playing as a guest',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.white,
                  fontSize: 24,
                  decoration: TextDecoration.none,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Store<AppState> store = StoreProvider.of<AppState>(context);
                  store.dispatch(LoadingAction(true));
                  await FirebaseAuth.instance.signInAnonymously();
                  store.dispatch(ToggleGameRegisterAction());
                  store.dispatch(LoadingAction(false));
                },
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
                      'Start!',
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
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
