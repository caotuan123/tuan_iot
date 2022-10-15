import 'package:iot_app/model/cmd_req.model.dart';
import 'package:iot_app/model/light.model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'iot.model.g.dart';

@JsonSerializable(explicitToJson: true)
class IoTModel {
  @JsonKey(name: 'Is_new_command')
  @JsonKey(defaultValue: false)
  bool isNotifyNewCommand;
  @JsonKey(name: 'Command_list')
  List<CmdReqModel> listCmdReqModel;

  Light light;

  IoTModel({this.isNotifyNewCommand = false, required this.listCmdReqModel, required this.light});

  factory IoTModel.fromJson(Map<String, dynamic> json) => _$IoTModelFromJson(json);

  Map<String, dynamic> toJson() => _$IoTModelToJson(this);
}
