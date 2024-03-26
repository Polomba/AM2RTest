// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => RouteModel(
      idStatus: json['idStatus'] as String,
      description: json['description'] as String,
      distance: (json['distance'] as num).toDouble(),
      id: json['_id'] as String,
      name: json['name'] as String,
      fileVersion: json['fileVersion'] as int?,
      filename: json['filename'] as String?,
      iqar: json['IQAr'] as int?,
      totalEvents: json['totalEvents'] as int?,
      totalPeople: json['totalPeople'] as int?,
    );

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'distance': instance.distance,
      'description': instance.description,
      'idStatus': instance.idStatus,
      'fileVersion': instance.fileVersion,
      'filename': instance.filename,
      'IQAr': instance.iqar,
      'totalPeople': instance.totalPeople,
      'totalEvents': instance.totalEvents,
    };
