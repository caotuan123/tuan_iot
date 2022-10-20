import 'package:json_annotation/json_annotation.dart';
part 'device.model.g.dart';

@JsonSerializable()
class DeviceModel {
  String name;
  String? status;
  @JsonKey(name: 'del_noti')
  String? deleteNotify;
  @JsonKey(name: 'crt_noti')
  String? createNotify;
  @JsonKey(name: 'is_crt')
  String? isNotifyCreate;
  @JsonKey(name: 'is_del')
  String? isNotifyDelete;

  DeviceModel({
    required this.name,
    this.status,
    this.deleteNotify = "",
    this.createNotify = "",
    this.isNotifyCreate ="0",
    this.isNotifyDelete ="0"
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}
