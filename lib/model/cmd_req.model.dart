import 'package:json_annotation/json_annotation.dart';
part 'cmd_req.model.g.dart';

@JsonSerializable()
class CmdReqModel {
   String cmd;
   String device;
   int type;
  CmdReqModel({required this.cmd, required this.device, required this.type});

  factory CmdReqModel.fromJson(Map<String, dynamic> json) => _$CmdReqModelFromJson(json);

  Map<String, dynamic> toJson() => _$CmdReqModelToJson(this);
}
