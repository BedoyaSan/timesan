import 'package:firebase_database/firebase_database.dart';

class DataFetch {
  static final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  static final DataFetch _dataFetch = DataFetch._internal();

  factory DataFetch() {
    return _dataFetch;
  }

  DataFetch._internal();
}

dynamic getDataFromUser() async {
  final snapshot = await DataFetch.databaseReference.get();
  if(snapshot.exists) {
    return snapshot.value;
  } else {
    await DataFetch.databaseReference.set({'san' : '123'}).then((value){
      return value;
    });
  }
}