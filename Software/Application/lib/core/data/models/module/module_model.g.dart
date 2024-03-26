// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleModel _$ModuleModelFromJson(Map<String, dynamic> json) => ModuleModel(
      idLocation: json['idLocation'] == null
          ? null
          : LocationModel.fromJson(json['idLocation'] as Map<String, dynamic>),
      idRoute: json['idRoute'] == null
          ? null
          : RouteModel.fromJson(json['idRoute'] as Map<String, dynamic>),
      id: json['_id'] as String?,
      name: json['name'] as String?,
      status: $enumDecodeNullable(_$ModuleStatusEnumMap, json['status']),
      iqAr: json['IQAr'] as int?,
      iqArLastUpdate: json['IQArUpdate'] as String?,
    );

Map<String, dynamic> _$ModuleModelToJson(ModuleModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'status': _$ModuleStatusEnumMap[instance.status],
      'idLocation': instance.idLocation,
      'idRoute': instance.idRoute,
      'IQAr': instance.iqAr,
      'IQArUpdate': instance.iqArLastUpdate,
    };

const _$ModuleStatusEnumMap = {
  ModuleStatus.active: 'active',
  ModuleStatus.desactive: 'desactive',
  ModuleStatus.mainetenance: 'mainetenance',
  ModuleStatus.outOfService: 'outOfService',
};
