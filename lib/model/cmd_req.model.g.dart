// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cmd_req.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CmdReqModel _$CmdReqModelFromJson(Map<String, dynamic> json) => CmdReqModel(
      cmd: json['cmd'] as String,
      device: json['device'] as String,
      type: json['type'] as int,
    );

Map<String, dynamic> _$CmdReqModelToJson(CmdReqModel instance) =>
    <String, dynamic>{
      'cmd': instance.cmd,
      'device': instance.device,
      'type': instance.type,
    };
