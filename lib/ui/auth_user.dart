import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/actions.dart';
import '../redux/app_state.dart';

class AuthUser extends StatelessWidget {
  const AuthUser({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || FirebaseAuth.instance.currentUser == null) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                  clientId:
                      '14787775543-hrqr6h8mknpuk4h5b8egv6qb8capivfu.apps.googleusercontent.com'),
            ],
            footerBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signInAnonymously();
                        },
                        child: const Text('Guest login')),
                    StoreConnector<AppState, VoidCallback>(converter: (store) {
                      return () => store.dispatch(SetViewAction('Home'));
                    }, builder: (context, callback) {
                      return OutlinedButton(
                          onPressed: callback,
                          child: const Text('Back to main menu'));
                    }),
                  ],
                ),
              );
            },
          );
        }
        print(FirebaseAuth.instance.currentUser);
        return StoreConnector<AppState, VoidCallback>(converter: (store) {
          return () => store.dispatch(SetViewAction('Home'));
        }, builder: (context, callback) {
          return ProfileScreen(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: OutlinedButton(
                    onPressed: callback,
                    child: const Text('Back to main menu')),
              )
            ],
          );
        });
      },
    );
  }
}
