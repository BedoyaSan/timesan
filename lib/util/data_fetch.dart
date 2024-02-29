import 'package:firebase_database/firebase_database.dart';

import '../redux/app_state.dart';

class DataFetch {
  static final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref();
  static final DataFetch _dataFetch = DataFetch._internal();

  factory DataFetch() {
    return _dataFetch;
  }

  DataFetch._internal();
}

dynamic getDataFromUser(String userId) async {
  final snapshot =
      await DataFetch.databaseReference.child('userData/$userId').get();
  if (snapshot.exists) {
    return snapshot.value;
  } else {
    TransferGameData gameData = TransferGameData();
    gameData.userId = userId;

    await DataFetch.databaseReference
        .child('userData/$userId')
        .set(gameData.toJson());

    return gameData;
  }
}

void saveDataFromUser(TransferGameData gameData, String userId) async {
  try {
    if (userId != '') {
      await DataFetch.databaseReference
          .child('userData/$userId')
          .set(gameData.toJson());
    }
  } catch (e) {
    //
  }
}
