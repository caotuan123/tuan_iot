import 'package:iot_app/model/cmd_req.model.dart';
import 'package:iot_app/model/light.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'lock.model.dart';

part 'iot.model.g.dart';

@JsonSerializable(explicitToJson: true)
class IoTModel {
  @JsonKey(name: 'is_new_command')
  @JsonKey(defaultValue: false)
  bool isNotifyNewCommand;
  @JsonKey(name: 'command_list')
  @JsonKey(defaultValue: [])
  List<CmdReqModel> listCmdReqModel;

  Light light;

  Lock lock;

  IoTModel({
    this.isNotifyNewCommand = false,
    this.listCmdReqModel = const [],
    required this.light,
    required this.lock,
  });

  factory IoTModel.fromJson(Map<String, dynamic> json) => _$IoTModelFromJson(json);

  Map<String, dynamic> toJson() => _$IoTModelToJson(this);
}
