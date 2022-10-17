// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cmd.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CmdModel _$CmdModelFromJson(Map<String, dynamic> json) => CmdModel(
      cmd: json['cmd'] as String,
      device: json['device'] as String,
      type: json['type'] as int,
    );

Map<String, dynamic> _$CmdModelToJson(CmdModel instance) => <String, dynamic>{
      'cmd': instance.cmd,
      'device': instance.device,
      'type': instance.type,
    };
