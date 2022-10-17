import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_app/data/firebase_datasouce.dart';
import 'package:iot_app/enum/enum.dart';
import 'package:iot_app/model/cmd.model.dart';
import 'package:iot_app/model/request.model.dart';
import 'package:iot_app/model/response.model.dart';
import 'package:iot_app/pathAPI/path_api_endpoint.dart';

class IoTController extends GetxController {
  final FirebaseDataSource _firebaseDataSource = FirebaseDataSource();

  ResponseModel responseModel = ResponseModel();

  List<CmdModel> listCmdModel = [];

  // Command_line for light (Request to firebase)
  final CmdModel cmdModelLight = CmdModel(
    cmd: StatusEnum.OFF,
    device: DeviceEnum.light,
    type: TypeNotifyEnum.TypeUpdate,
  );

  // Command_line for lock (Request to firebase)
  final CmdModel cmdModelLock = CmdModel(
    cmd: StatusEnum.OFF,
    device: DeviceEnum.lock,
    type: TypeNotifyEnum.TypeUpdate,
  );

// READ FROM FIREBASE
  Stream<DatabaseEvent> notifyNewCmdStream() =>
      _firebaseDataSource.dataStream('${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.isNewCommand}');

  Stream<DatabaseEvent> listDeviceStream() =>
      _firebaseDataSource.dataStream('${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.device}');

  Future<void> setStatusLock(bool newStatus) async {
    cmdModelLock.cmd = newStatus ? StatusEnum.OPEN : StatusEnum.CLOSED;
    cmdModelLock.type = TypeNotifyEnum.TypeReq;
    listCmdModel.add(cmdModelLock);
    final RequestModel requestModel = RequestModel(
      listCmdModel: listCmdModel,
      isNotifyNewCommand: true,
    );
    await _setData(data: requestModel.toJson());
  }

  Future<void> setStatusLight(bool newStatus) async {
    cmdModelLight.cmd = newStatus ? StatusEnum.ON : StatusEnum.OFF;
    cmdModelLight.type = TypeNotifyEnum.TypeReq;
    listCmdModel.add(cmdModelLight);
    final RequestModel requestModel = RequestModel(
      listCmdModel: listCmdModel,
      isNotifyNewCommand: true,
    );
    await _setData(data: requestModel.toJson());
  }

  Future<void> _setData({required Map<String, dynamic> data}) async {
    await _firebaseDataSource.setData(data: data);
  }

  void statusFromServer(AsyncSnapshot<Object> snapshot) {
    final DatabaseEvent event = snapshot.data as DatabaseEvent;
    final rawData = jsonDecode(jsonEncode(event.snapshot.value));
    responseModel = ResponseModel.fromJson(rawData);
  }

  bool get statusLight =>
      responseModel.listDevice.firstWhere((e) => e.name == DeviceEnum.light).status == StatusEnum.ON;
  bool get statusLock =>
      responseModel.listDevice.firstWhere((e) => e.name == DeviceEnum.lock).status == StatusEnum.OPEN;

  @override
  void onInit() {
    notifyNewCmdStream().listen((event) {
      final bool isNewCmd = jsonDecode(jsonEncode(event.snapshot.value));
      if (!isNewCmd) {
        listCmdModel.clear();
      }
    });
    super.onInit();
  }
}
