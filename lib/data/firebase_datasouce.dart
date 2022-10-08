import 'package:firebase_database/firebase_database.dart';

class FirebaseDataSource {
  final DatabaseReference _dbRefe = FirebaseDatabase.instance.ref();

  DatabaseReference get dbRefe => _dbRefe;
  Future<void> setData({required Map<String, dynamic> data, required String path}) async {
    await _dbRefe.child(path).set(data);
  }

  Stream<DatabaseEvent> dataStream(String path) => _dbRefe.child(path).onValue;
}
