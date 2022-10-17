// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestModel _$RequestModelFromJson(Map<String, dynamic> json) => RequestModel(
      listCmdModel: (json['list_command'] as List<dynamic>?)
              ?.map((e) => CmdModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isNotifyNewCommand: json['is_new_command'] as bool? ?? false,
    );

Map<String, dynamic> _$RequestModelToJson(RequestModel instance) =>
    <String, dynamic>{
      'list_command': instance.listCmdModel.map((e) => e.toJson()).toList(),
      'is_new_command': instance.isNotifyNewCommand,
    };
