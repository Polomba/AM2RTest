import 'package:json_annotation/json_annotation.dart';

part 'measurement_model.g.dart';

@JsonSerializable()
class MeasurementModel {
  final String id;
  final String idSensor;
  final String idSensorType;
  final DateTime createdAt;
  final double value;
  final bool isValidMeasurement;

  MeasurementModel({
    required this.createdAt,
    required this.id,
    required this.idSensor,
    required this.idSensorType,
    required this.isValidMeasurement,
    required this.value,
  });

  factory MeasurementModel.fromJson(Map<String, dynamic> json) =>
      _$MeasurementModelFromJson(json);
  Map<String, dynamic> toJson() => _$MeasurementModelToJson(this);
}
