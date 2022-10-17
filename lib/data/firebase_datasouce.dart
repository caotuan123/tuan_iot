import 'package:firebase_database/firebase_database.dart';
import 'package:iot_app/pathAPI/path_api_endpoint.dart';

class FirebaseDataSource {
  final DatabaseReference _dbRefe = FirebaseDatabase.instance.ref();

  DatabaseReference get dbRefe => _dbRefe;
  Future<void> setData({required Map<String, dynamic> data}) async {
    // If use set method that's make extinct data will be overwritten (list_device path must be stay always)
    await _dbRefe.child(PathAPIEndpoint.baseAPI).update(data);
  }

  Stream<DatabaseEvent> dataStream(String path) => _dbRefe.child(path).onValue;
}
