import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_app/data/firebase_datasouce.dart';
import 'package:iot_app/enum/enum.dart';
import 'package:iot_app/model/cmd.model.dart';
import 'package:iot_app/model/device.model.dart';
import 'package:iot_app/model/request.model.dart';
import 'package:iot_app/model/response.model.dart';
import 'package:iot_app/pathAPI/path_api_endpoint.dart';

class IoTController extends GetxController {
  final FirebaseDataSource _firebaseDataSource = FirebaseDataSource();

  ResponseModel responseModel = ResponseModel();

  List<CmdModel> listCmdModel = [];

  final RxString notifyMessage = "".obs;

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

  // Command_line for lock (Request to firebase)
  final CmdModel cmdModelRifd = CmdModel(
    cmd: MethodEnum.NEW,
    device: DeviceEnum.rifd,
    type: TypeNotifyEnum.TypeUpdate,
  );

// READ FROM FIREBASE
  Stream<DatabaseEvent> notifyNewCmdStream() =>
      _firebaseDataSource.dataStream('${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.isNewCommand}');

  Stream<DatabaseEvent> listDeviceStream() =>
      _firebaseDataSource.dataStream('${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.device}');

  Stream<DatabaseEvent> rfidStream() =>
      _firebaseDataSource.dataStream('${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.device}/2');

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

  Future<void> newID() async {
    cmdModelRifd.cmd = MethodEnum.NEW;
    cmdModelRifd.type = TypeNotifyEnum.TypeReq;
    listCmdModel.add(cmdModelRifd);
    final RequestModel requestModel = RequestModel(
      listCmdModel: listCmdModel,
      isNotifyNewCommand: true,
    );
    await _setData(data: requestModel.toJson());
  }

  Future<void> deleteID() async {
    cmdModelRifd.cmd = MethodEnum.DELETE;
    cmdModelRifd.type = TypeNotifyEnum.TypeReq;
    listCmdModel.add(cmdModelRifd);
    final RequestModel requestModel = RequestModel(
      listCmdModel: listCmdModel,
      isNotifyNewCommand: true,
    );
    await _setData(data: requestModel.toJson());
  }

  Future<void> _setData({required Map<String, dynamic> data}) async {
    await _firebaseDataSource.setData(data: data);
  }

  Future<void> _resetNotifyRfid({required Map<String, dynamic> data}) async {
    await _firebaseDataSource.setData(data: data, path: '${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.device}/2');
  }

  void getDataFromServer(AsyncSnapshot<Object> snapshot) {
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

  @override
  void onReady() {
    rfidStream().listen((event) {
      final rawData = jsonDecode(jsonEncode(event.snapshot.value));
      final DeviceModel rfid = DeviceModel.fromJson(rawData);
      if (rfid.isNotifyCreate == "1" && rfid.createNotify != "") {
        Get.snackbar('Notification', '${rfid.createNotify}', snackPosition: SnackPosition.BOTTOM);
        _resetNotifyRfid(data: {
          'is_crt': "0",
          'crt_noti': "",
        });
      }
      if (rfid.isNotifyDelete == "1" && rfid.deleteNotify != "") {
        Get.snackbar('Notification', '${rfid.deleteNotify}', snackPosition: SnackPosition.BOTTOM);
        _resetNotifyRfid(data: {
          'is_crt': "0",
          'del_noti': "",
        });
      }
    });
    super.onReady();
  }
}
