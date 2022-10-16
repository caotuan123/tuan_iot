import 'package:iot_app/enum/enum.dart';
import 'package:json_annotation/json_annotation.dart';
part 'lock.model.g.dart';

@JsonSerializable()
class Lock {
  String status;
  Lock({required this.status});

  bool? get statusUI {
    if (status == StatusEnum.OPEN) {
      return true;
    }
    if (status == StatusEnum.CLOSED) {
      return false;
    }
    return null;
  }

  factory Lock.fromJson(Map<String, dynamic> json) => _$LockFromJson(json);
  Map<String, dynamic> toJson() => _$LockToJson(this);
}
