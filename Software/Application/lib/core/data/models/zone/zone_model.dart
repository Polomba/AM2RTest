import 'package:json_annotation/json_annotation.dart';

part 'zone_model.g.dart';

@JsonSerializable()
class ZoneModel {
  final String id;
  final String idRoute;
  final String name;
  final double distance;
  final String idStartModule;
  final String idEndModule;
  final String description;
  final DateTime createdAt;

  ZoneModel({
    required this.createdAt,
    required this.description,
    required this.distance,
    required this.id,
    required this.idEndModule,
    required this.idRoute,
    required this.idStartModule,
    required this.name,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) =>
      _$ZoneModelFromJson(json);
  Map<String, dynamic> toJson() => _$ZoneModelToJson(this);
}
