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

  ResponseModel responseModel = ResponseModel(); //

  List<CmdModel> listCmdModel = []; //request de gui len firebase

  final RxString notifyMessage = "".obs;

  // Command_line for light (Request to firebase)
  final CmdModel cmdModelLight0 = CmdModel(
    cmd: StatusEnum.OFF,
    device: DeviceEnum.light_0,
    type: TypeNotifyEnum.TypeUpdate,
  );

  final CmdModel cmdModelLight1 = CmdModel(
    cmd: StatusEnum.OFF,
    device: DeviceEnum.light_1,
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
  Stream<DatabaseEvent> notifyNewCmdStream() => _firebaseDataSource
      .dataStream('${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.isNewCommand}');

  Stream<DatabaseEvent> listDeviceStream() => _firebaseDataSource
      .dataStream('${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.device}');

  Stream<DatabaseEvent> rfidStream() => _firebaseDataSource
      .dataStream('${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.device}/2');

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

  Future<void> setStatusLight0(bool newStatus) async {
    cmdModelLight0.cmd = newStatus ? StatusEnum.ON : StatusEnum.OFF;
    cmdModelLight0.type = TypeNotifyEnum.TypeReq;
    listCmdModel.add(cmdModelLight0);
    final RequestModel requestModel = RequestModel(
      listCmdModel: listCmdModel,
      isNotifyNewCommand: true,
    );
    await _setData(data: requestModel.toJson());
  }

  Future<void> setStatusLight1(bool newStatus) async {
    cmdModelLight1.cmd = newStatus ? StatusEnum.ON : StatusEnum.OFF;
    cmdModelLight1.type = TypeNotifyEnum.TypeReq;
    listCmdModel.add(cmdModelLight1);
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
    await _firebaseDataSource.setData(
        data: data,
        path: '${PathAPIEndpoint.baseAPI}/${PathAPIEndpoint.device}/2');
  }

  void getDataFromServer(AsyncSnapshot<Object> snapshot) {
    final DatabaseEvent event = snapshot.data as DatabaseEvent;
    final rawData = jsonDecode(jsonEncode(event.snapshot.value));
    responseModel = ResponseModel.fromJson(rawData);
  }

  bool get statusLight0 =>
      responseModel.listDevice
          .firstWhere((e) => e.name == DeviceEnum.light_0)
          .status ==
      StatusEnum.ON;
  bool get statusLight1 =>
      responseModel.listDevice
          .firstWhere((e) => e.name == DeviceEnum.light_1)
          .status ==
      StatusEnum.ON;
  bool get statusLock =>
      responseModel.listDevice
          .firstWhere((e) => e.name == DeviceEnum.lock)
          .status ==
      StatusEnum.OPEN;

  String? get valueTemp =>
      responseModel.listDevice
          .firstWhere((e) => e.name == DeviceEnum.temp_sen).status;
          

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
      //chay xuyen suot
      final rawData = jsonDecode(jsonEncode(event.snapshot.value));
      final DeviceModel rfid = DeviceModel.fromJson(rawData);
      if (rfid.isNotifyCreate == "1" && rfid.createNotify != "") {
        Get.snackbar('Notification', '${rfid.createNotify}',
            snackPosition: SnackPosition.BOTTOM);
        _resetNotifyRfid(data: {
          'is_crt': "0",
          'crt_noti': "",
        });
      }
      if (rfid.isNotifyDelete == "1" && rfid.deleteNotify != "") {
        Get.snackbar('Notification', '${rfid.deleteNotify}',
            snackPosition: SnackPosition.BOTTOM);
        _resetNotifyRfid(data: {
          'is_crt': "0",
          'del_noti': "",
        });
      }
    });
    super.onReady();
  }
}
