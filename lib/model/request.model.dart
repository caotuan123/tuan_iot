import 'package:iot_app/model/cmd.model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'request.model.g.dart';

@JsonSerializable(explicitToJson: true)
class RequestModel {
  @JsonKey(name: 'list_command')
  List<CmdModel> listCmdModel;
  @JsonKey(name: 'is_new_command')
  @JsonKey(defaultValue: false)
  bool isNotifyNewCommand;
  RequestModel({this.listCmdModel = const [], this.isNotifyNewCommand = false});

  factory RequestModel.fromJson(Map<String, dynamic> json) => _$RequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestModelToJson(this);

}
