import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

Widget infoScreen(BuildContext context, String message) {
  return GestureDetector(
    onTap: () {
      widgetStatus.value['gameInfo'] = false;
      widgetStatus.notifyListeners();
    },
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.7),
      child: Center(
          child: Flexible(
        fit: FlexFit.tight,
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
              child: Text(
                message,
                style: GoogleFonts.robotoCondensed(
                  color: Colors.white,
                  fontSize: 24,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      )),
    ),
  );
}
