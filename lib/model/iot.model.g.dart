// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IoTModel _$IoTModelFromJson(Map<String, dynamic> json) => IoTModel(
      isNotifyNewCommand: json['is_new_command'] as bool? ?? false,
      listCmdReqModel: (json['command_list'] as List<dynamic>?)
              ?.map((e) => CmdReqModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      light: Light.fromJson(json['light'] as Map<String, dynamic>),
      lock: Lock.fromJson(json['lock'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IoTModelToJson(IoTModel instance) => <String, dynamic>{
      'is_new_command': instance.isNotifyNewCommand,
      'command_list': instance.listCmdReqModel.map((e) => e.toJson()).toList(),
      'light': instance.light.toJson(),
      'lock': instance.lock.toJson(),
    };
