import 'package:iot_app/model/device.model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'response.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseModel {
  @JsonKey(name: 'list_device')
  List<DeviceModel> listDevice;
  ResponseModel({this.listDevice = const []});
  // NEED TO IMPROVE
  factory ResponseModel.fromJson(List<dynamic> json) {
    final List<DeviceModel> listDevice = [];
    for (var e in json) {
      listDevice.add(DeviceModel.fromJson(e));

     }
    return ResponseModel(listDevice: listDevice);
  }

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
