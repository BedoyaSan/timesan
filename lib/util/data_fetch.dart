import 'package:firebase_auth/firebase_auth.dart';
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

Future<String> updateGardensId(String gardenId, String oldGardenId) async {
  try {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    //Check if the id is taken
    DataSnapshot getGardenId =
        await DataFetch.databaseReference.child('friendsIds/$gardenId').get();
    if (getGardenId.exists && getGardenId.value != null) {
      if (getGardenId.value as String != userId) {
        return 'The identifier is already taken by someone else';
      }
    }
    //Remove the old id
    if (oldGardenId != '') {
      DataSnapshot getOldGardenId = await DataFetch.databaseReference
          .child('friendsIds/$oldGardenId')
          .get();
      if (getOldGardenId.exists && getOldGardenId.value != null) {
        if (getOldGardenId.value as String != userId) {
          return 'There has been an error, please try again later';
        }
        await DataFetch.databaseReference
            .child('friendsIds/$oldGardenId')
            .remove();
      }
    }

    if (userId != '') {
      await DataFetch.databaseReference
          .child('userData/$userId/userGardenId')
          .set(gardenId);
      await DataFetch.databaseReference
          .child('friendsIds/$gardenId')
          .set(userId);
      return 'OK';
    }
  } catch (e) {
    return e.toString();
  }
  return '';
}

dynamic getGardenFriend(String id) async {
  try {
    DataSnapshot data = await DataFetch.databaseReference.child('friendsIds/$id').get();
    String friendId = '';

    if(data.exists) {
      if(data.value != null && data.value is String) {
        friendId = data.value as String;
      }
    } else {
      return 'Not found, check again';
    }

    if(friendId != '') {
      if(friendId == FirebaseAuth.instance.currentUser?.uid) {
        return 'That appears to be your id, not the best way to access your garden';
      }

      DataSnapshot gardenData = await DataFetch.databaseReference.child('userData/$friendId/gardenGame').get();
      if(gardenData.exists) {
        return gardenData.value;
      }
      return 'We couldn\'t find your friend\'s garden';
    }

  } catch (e) {
    //
  }
  return 'There has been a technical error';
}