// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IoTModel _$IoTModelFromJson(Map<String, dynamic> json) => IoTModel(
      isNotifyNewCommand: json['Is_new_command'] as bool? ?? false,
      listCmdReqModel: (json['Command_list'] as List<dynamic>)
          .map((e) => CmdReqModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      light: Light.fromJson(json['light'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IoTModelToJson(IoTModel instance) => <String, dynamic>{
      'Is_new_command': instance.isNotifyNewCommand,
      'Command_list': instance.listCmdReqModel.map((e) => e.toJson()).toList(),
      'light': instance.light.toJson(),
    };
