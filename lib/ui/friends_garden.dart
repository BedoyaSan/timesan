import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../util/assets.dart';
import '../util/data_fetch.dart';
import '../util/garden.dart';

class FriendsGarden extends StatefulWidget {
  const FriendsGarden({super.key});

  @override
  State<FriendsGarden> createState() => _FriendsGardenState();
}

class _FriendsGardenState extends State<FriendsGarden> {
  final TextEditingController _gardenIdController = TextEditingController();
  final TextEditingController _friendIdController = TextEditingController();

  String gardenIdValue = '';
  String friendIdValue = '';

  String updatingMessage = '';
  String getGardenMessage = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Store<AppState> store = StoreProvider.of<AppState>(context);
      gardenIdValue = store.state.userGardenId;
      _gardenIdController.text = store.state.userGardenId;
    });

    _gardenIdController.addListener(() {
      setState(() {
        gardenIdValue = _gardenIdController.value.text;
        updatingMessage = '';
      });
    });
    _friendIdController.addListener(() {
      setState(() {
        friendIdValue = _friendIdController.value.text;
        getGardenMessage = '';
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    double widthValue = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.black.withOpacity(0.1),
      child: GestureDetector(
        onTap: () {
          store.dispatch(ToggleFriendsGardenAction());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.5),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Enter an id to view your friend\'s garden',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 24,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: widthValue * 0.2,
                        right: widthValue * 0.2,
                      ),
                      child: TextFormField(
                        controller: _friendIdController,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.cyan,
                          fontSize: 24,
                          decoration: TextDecoration.none,
                        ),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          iconColor: Color.fromARGB(255, 46, 86, 155),
                          suffixIcon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getGardenMessage != ''
                        ? Text(
                            getGardenMessage,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.rubikGlitch(
                              color: Colors.redAccent.shade400,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          )
                        : (friendIdValue != ''
                            ? GestureDetector(
                                onTap: () async {
                                  Store<AppState> store =
                                      StoreProvider.of<AppState>(context);

                                  store.dispatch(LoadingAction(true));
                                  dynamic gardenData =
                                      await getGardenFriend(friendIdValue);
                                  if (gardenData != null) {
                                    if (gardenData is String) {
                                      setState(() {
                                        getGardenMessage = gardenData;
                                      });
                                    } else {
                                      try {
                                        GardenData garden = GardenData.fromJson(gardenData as List<dynamic>);
                                        store.dispatch(SaveFriendGardenAction(garden));
                                        store.dispatch(SetViewAction('FriendsGarden'));
                                        store.dispatch(ToggleFriendsGardenAction());
                                        store.dispatch(ToggleGameSelectAction());
                                      } catch (e) {
                                        setState(() {
                                          getGardenMessage = 'A technical error has ocurred';
                                        });
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      getGardenMessage =
                                          'There has been an error';
                                    });
                                  }
                                  store.dispatch(LoadingAction(false));
                                },
                                child: Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(top: 16),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage(AssetsUI.hexBorderButton),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      'View this garden',
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
                              )
                            : Container()),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Create an unique identifier and share it, so others can look your garden',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 24,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: widthValue * 0.2,
                        right: widthValue * 0.2,
                      ),
                      child: TextFormField(
                        controller: _gardenIdController,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.cyan,
                          fontSize: 24,
                          decoration: TextDecoration.none,
                        ),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          iconColor: Color.fromARGB(255, 46, 86, 155),
                          suffixIcon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    updatingMessage != ''
                        ? Text(
                            updatingMessage,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.rubikGlitch(
                              color: Colors.cyan,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          )
                        : (gardenIdValue != '' &&
                                gardenIdValue != store.state.userGardenId
                            ? GestureDetector(
                                onTap: () async {
                                  store.dispatch(LoadingAction(true));
                                  String resultUpdate = await updateGardensId(
                                      gardenIdValue, store.state.userGardenId);
                                  if (resultUpdate == 'OK') {
                                    store.dispatch(
                                        SaveGardenIdAction(gardenIdValue));
                                    resultUpdate =
                                        'Your id has been updated to $gardenIdValue';
                                  }
                                  setState(() {
                                    updatingMessage = resultUpdate;
                                  });
                                  store.dispatch(LoadingAction(false));
                                },
                                child: Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(top: 16),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage(AssetsUI.hexBorderButton),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      'Update my identifier',
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
                              )
                            : Container()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
