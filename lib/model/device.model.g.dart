// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
      name: json['name'] as String,
      status: json['status'] as String?,
      deleteNotify: json['del_noti'] as String? ?? "",
      createNotify: json['crt_noti'] as String? ?? "",
      isNotifyCreate: json['is_crt'] as String? ?? "0",
      isNotifyDelete: json['is_del'] as String? ?? "0",
    );

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'status': instance.status,
      'del_noti': instance.deleteNotify,
      'crt_noti': instance.createNotify,
      'is_crt': instance.isNotifyCreate,
      'is_del': instance.isNotifyDelete,
    };
