import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../util/assets.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 38),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(45),
                color: const Color.fromARGB(255, 37, 37, 38),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Time\'s an Adventure',
                          style: GoogleFonts.rubikGlitch(
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 42.0,
                            decoration: TextDecoration.none,
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Welcome, ${(FirebaseAuth.instance.currentUser != null) ? (FirebaseAuth.instance.currentUser?.displayName ?? '') : 'Anonymous user'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            decoration: TextDecoration.none,
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        mainButton('Start simulation', 'selectGame'),
                        mainButton('How to play', 'gameInfo'),
                        mainButton(
                            (FirebaseAuth.instance.currentUser == null)
                                ? 'Log in'
                                : 'User info',
                            'Authentication'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, right: 15),
                      child: Text(
                        'Beta version 0.2',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: GoogleFonts.rubikGlitch(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget mainButton(String label, String value) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        switch (value) {
          case 'selectGame':
            return () => store.dispatch(ToggleGameSelectAction());
          case 'gameInfo':
            return () => store.dispatch(ToggleGameInfoAction());
          case 'Authentication':
            return () => store.dispatch(SetViewAction(value));

          default:
            return () => store.dispatch(SetViewAction('Home'));
        }
      },
      builder: (context, callback) {
        return GestureDetector(
          onTap: callback,
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
                style:
                    GoogleFonts.rubikGlitch(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}
