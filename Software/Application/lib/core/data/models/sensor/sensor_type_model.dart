import 'package:json_annotation/json_annotation.dart';

part 'sensor_type_model.g.dart';

@JsonSerializable()
class SensorTypeModel {
  final String id;
  final String idPhysicalQuantity;
  final double max;
  final double min;

  SensorTypeModel({
    required this.id,
    required this.idPhysicalQuantity,
    required this.max,
    required this.min,
  });

  factory SensorTypeModel.fromJson(Map<String, dynamic> json) =>
      _$SensorTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$SensorTypeModelToJson(this);
}
