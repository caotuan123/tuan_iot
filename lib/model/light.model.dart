import 'package:iot_app/enum/enum.dart';
import 'package:json_annotation/json_annotation.dart';
part 'light.model.g.dart';

@JsonSerializable()
class Light {
  String status;
  Light({required this.status});

  bool? get statusUI {
    if (status == StatusEnum.ON) {
      return true;
    }
    if (status == StatusEnum.OFF) {
      return false;
    }
    return null;
  }

  factory Light.fromJson(Map<String, dynamic> json) => _$LightFromJson(json);

  Map<String, dynamic> toJson() => _$LightToJson(this);
}
