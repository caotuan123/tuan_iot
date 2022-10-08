import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_app/data/firebase_datasouce.dart';
import 'package:iot_app/model/light.model.dart';
import 'package:iot_app/pathAPI/path_api_endpoint.dart';

class LightController extends GetxController {
  final FirebaseDataSource _firebaseDataSource = FirebaseDataSource();

  Stream<DatabaseEvent> lightStatusStream() => _firebaseDataSource.dataStream(PathAPIEndpoint.light);

  final Rx<Light> light = Light(status: true).obs;

  Future<void> setStatusLight(bool newStatus) async {
    light.update((val) {
      val?.status = newStatus;
    });
    final Map<String, dynamic> lightData = {"status": light.value.status};
    await _updateLightData(lightData: lightData);
  }

  Future<void> _updateLightData({required Map<String, dynamic> lightData}) async {
    await _firebaseDataSource.setData(path: PathAPIEndpoint.light, data: lightData);
  }

  bool statusFromServer(AsyncSnapshot<Object> snapshot) {
    return Map<dynamic, dynamic>.from(
        (snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>)["status"];
  }
}
