import 'package:json_annotation/json_annotation.dart';
part 'device.model.g.dart';

@JsonSerializable()
class DeviceModel {
  String name;
  String? status;
  DeviceModel({
    required this.name,
    this.status,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}
