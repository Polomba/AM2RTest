// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_events_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleEventsModel _$ModuleEventsModelFromJson(Map<String, dynamic> json) =>
    ModuleEventsModel(
      createdAt: DateTime.parse(json['createdAt'] as String),
      eventType: $enumDecode(_$EventTypeEnumMap, json['eventType']),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      id: json['id'] as String,
      idLocation: json['idLocation'] as String,
      idModule: json['idModule'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ModuleEventsModelToJson(ModuleEventsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idModule': instance.idModule,
      'eventType': _$EventTypeEnumMap[instance.eventType]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'finishedAt': instance.finishedAt.toIso8601String(),
      'isActive': instance.isActive,
      'idLocation': instance.idLocation,
    };

const _$EventTypeEnumMap = {
  EventType.unknown: 'unknown',
  EventType.colision: 'colision',
  EventType.obstruction: 'obstruction',
  EventType.traffic: 'traffic',
};
