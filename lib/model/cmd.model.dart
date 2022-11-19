import 'package:json_annotation/json_annotation.dart';
part 'cmd.model.g.dart';

@JsonSerializable()
class CmdModel {
  String cmd;
  String device;
  int type;
  CmdModel({required this.cmd, required this.device, required this.type});

  factory CmdModel.fromJson(Map<String, dynamic> json) => _$CmdModelFromJson(json);//de doc firebase

  Map<String, dynamic> toJson() => _$CmdModelToJson(this);
}
