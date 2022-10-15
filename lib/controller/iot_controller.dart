import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_app/data/firebase_datasouce.dart';
import 'package:iot_app/enum/enum.dart';
import 'package:iot_app/model/cmd_req.model.dart';
import 'package:iot_app/model/iot.model.dart';
import 'package:iot_app/model/light.model.dart';
import 'package:iot_app/pathAPI/path_api_endpoint.dart';

class IoTController extends GetxController {
  final Rx<IoTModel> iOTModel = IoTModel(
    listCmdReqModel: [],
    light: Light(status: StatusEnum.OFF),
  ).obs;

  // Command_line for light (Request to firebase)
  final Rx<CmdReqModel> cmdReqModelLight = CmdReqModel(
    cmd: StatusEnum.OFF,
    device: DeviceEnum.light,
    type: TypeNotifyEnum.TypeUpdate,
  ).obs;

  final FirebaseDataSource _firebaseDataSource = FirebaseDataSource();

  Stream<DatabaseEvent> lightStatusStream() =>
      _firebaseDataSource.dataStream('${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.light}');

  Future<void> setStatusLight(bool newStatus) async {
    cmdReqModelLight.update((val) {
      val?.cmd = newStatus ? StatusEnum.ON : StatusEnum.OFF;
      val?.type = TypeNotifyEnum.TypeReq;
    });
    iOTModel.update((val) {
      val?.listCmdReqModel = [cmdReqModelLight.value];
      val?.isNotifyNewCommand = true;
    });
    await _updateLightData();
  }

  Future<void> _updateLightData() async {
    await _firebaseDataSource.setData(path: PathAPIEndpoint.baseAPI, data: iOTModel.value.toJson());
    // 1  // list_cmd = [cmdReqModelLight]
    // new iOTmodel (list_cmd, true),
    // upload to firebase
    // is_new_command: true == > list_cmd still has contain old value == > list_cmd.add(cmdReqModelDoor)
    // is_new_command: false == > list_cmd has been reset (isEmpty []) ==> list_cmd = [cmdReqModelDoor]
  }

  void lightStatusFromServer(AsyncSnapshot<Object> snapshot) {
    final String? lightStatus =
        Map<dynamic, dynamic>.from((snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>)["status"];
    iOTModel.update((val) {
      val?.light.status = lightStatus!;
    });
  }

  bool get statusLight => iOTModel.value.light.statusUI!;
}
