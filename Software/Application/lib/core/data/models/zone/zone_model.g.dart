// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZoneModel _$ZoneModelFromJson(Map<String, dynamic> json) => ZoneModel(
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String,
      distance: (json['distance'] as num).toDouble(),
      id: json['id'] as String,
      idEndModule: json['idEndModule'] as String,
      idRoute: json['idRoute'] as String,
      idStartModule: json['idStartModule'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ZoneModelToJson(ZoneModel instance) => <String, dynamic>{
      'id': instance.id,
      'idRoute': instance.idRoute,
      'name': instance.name,
      'distance': instance.distance,
      'idStartModule': instance.idStartModule,
      'idEndModule': instance.idEndModule,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };
