// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementModel _$MeasurementModelFromJson(Map<String, dynamic> json) =>
    MeasurementModel(
      createdAt: DateTime.parse(json['createdAt'] as String),
      id: json['id'] as String,
      idSensor: json['idSensor'] as String,
      idSensorType: json['idSensorType'] as String,
      isValidMeasurement: json['isValidMeasurement'] as bool,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$MeasurementModelToJson(MeasurementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idSensor': instance.idSensor,
      'idSensorType': instance.idSensorType,
      'createdAt': instance.createdAt.toIso8601String(),
      'value': instance.value,
      'isValidMeasurement': instance.isValidMeasurement,
    };
