import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  @JsonKey(name: '_id')
  final String id;
  final double altitude;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'freguesia')
  final String? town;

  LocationModel({
    required this.id,
    required this.altitude,
    required this.latitude,
    required this.longitude,
    this.town,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
