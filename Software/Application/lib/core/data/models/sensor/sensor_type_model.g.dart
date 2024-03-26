// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorTypeModel _$SensorTypeModelFromJson(Map<String, dynamic> json) =>
    SensorTypeModel(
      id: json['id'] as String,
      idPhysicalQuantity: json['idPhysicalQuantity'] as String,
      max: (json['max'] as num).toDouble(),
      min: (json['min'] as num).toDouble(),
    );

Map<String, dynamic> _$SensorTypeModelToJson(SensorTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idPhysicalQuantity': instance.idPhysicalQuantity,
      'max': instance.max,
      'min': instance.min,
    };
