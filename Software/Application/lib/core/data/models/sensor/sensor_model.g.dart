// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorModel _$SensorModelFromJson(Map<String, dynamic> json) => SensorModel(
      id: json['id'] as String,
      createDate: DateTime.parse(json['createDate'] as String),
      idModule: json['idModule'] as String,
    );

Map<String, dynamic> _$SensorModelToJson(SensorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createDate': instance.createDate.toIso8601String(),
      'idModule': instance.idModule,
    };
