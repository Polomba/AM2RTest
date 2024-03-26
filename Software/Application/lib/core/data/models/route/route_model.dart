import 'package:json_annotation/json_annotation.dart';

part 'route_model.g.dart';

@JsonSerializable()
class RouteModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final double distance;
  final String description;
  final String idStatus;
  int? fileVersion;
  String? filename;
  @JsonKey(name: 'IQAr')
  int? iqar;
  int? totalPeople;
  int? totalEvents;

  RouteModel({
    required this.idStatus,
    required this.description,
    required this.distance,
    required this.id,
    required this.name,
    this.fileVersion,
    this.filename,
    this.iqar,
    this.totalEvents,
    this.totalPeople,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);
  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}
