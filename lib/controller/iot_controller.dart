import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_app/data/firebase_datasouce.dart';
import 'package:iot_app/enum/enum.dart';
import 'package:iot_app/model/cmd_req.model.dart';
import 'package:iot_app/model/iot.model.dart';
import 'package:iot_app/model/light.model.dart';
import 'package:iot_app/model/lock.model.dart';
import 'package:iot_app/pathAPI/path_api_endpoint.dart';

class IoTController extends GetxController {
  bool isNewCommand = true;

  final List<CmdReqModel> _listCmdReq = [];

  final Rx<IoTModel> iOTModel = IoTModel(
    listCmdReqModel: [],
    light: Light(status: StatusEnum.OFF),
    lock: Lock(status: StatusEnum.CLOSED),
  ).obs;

  // Command_line for light (Request to firebase)
  final CmdReqModel cmdReqModelLight = CmdReqModel(
    cmd: StatusEnum.OFF,
    device: DeviceEnum.light,
    type: TypeNotifyEnum.TypeUpdate,
  );

  // Command_line for lock (Request to firebase)
  final CmdReqModel cmdReqModelLock = CmdReqModel(
    cmd: StatusEnum.OFF,
    device: DeviceEnum.lock,
    type: TypeNotifyEnum.TypeUpdate,
  );

  final FirebaseDataSource _firebaseDataSource = FirebaseDataSource();

// READ FROM FIREBASE
  Stream<DatabaseEvent> ioTStream() => _firebaseDataSource.dataStream(PathAPIEndpoint.baseAPI);

  Future<void> setStatusLock(bool newStatus) async {
    cmdReqModelLock.cmd = newStatus ? StatusEnum.OPEN : StatusEnum.CLOSED;
    cmdReqModelLock.type = TypeNotifyEnum.TypeReq;
    _listCmdReq.add(cmdReqModelLock);
    iOTModel.update((val) {
      val?.listCmdReqModel = _listCmdReq;
      val?.isNotifyNewCommand = true;
    });
    await _updateStatusData();
  }

  Future<void> setStatusLight(bool newStatus) async {
    cmdReqModelLight.cmd = newStatus ? StatusEnum.ON : StatusEnum.OFF;
    cmdReqModelLight.type = TypeNotifyEnum.TypeReq;
    _listCmdReq.add(cmdReqModelLight);
    iOTModel.update((val) {
      val?.listCmdReqModel = _listCmdReq;
      val?.isNotifyNewCommand = true;
    });
    await _updateStatusData();
  }

  Future<void> _updateStatusData() async {
    await _firebaseDataSource.setData(
      path: PathAPIEndpoint.baseAPI,
      data: iOTModel.value.toJson(),
    );
  }

  void statusFromServer(AsyncSnapshot<Object> snapshot) {
    final DatabaseEvent event = snapshot.data as DatabaseEvent;
    final rawData = jsonDecode(jsonEncode(event.snapshot.value));
    iOTModel.value = IoTModel.fromJson(rawData);
  }

  bool get statusLight => iOTModel.value.light.statusUI!;
  bool get statusLock => iOTModel.value.lock.statusUI!;

  @override
  void onInit() {
    ioTStream().listen((event) {
      final rawData = jsonDecode(jsonEncode(event.snapshot.value));
      final IoTModel ioTModel = IoTModel.fromJson(rawData);
      if (!ioTModel.isNotifyNewCommand) {
        _listCmdReq.clear();
      }
    });
    super.onInit();
  }
}
