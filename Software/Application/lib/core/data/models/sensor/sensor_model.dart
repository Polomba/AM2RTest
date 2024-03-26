import 'package:json_annotation/json_annotation.dart';

part 'sensor_model.g.dart';

@JsonSerializable()
class SensorModel {
  final String id;
  final DateTime createDate;
  final String idModule;

  SensorModel({
    required this.id,
    required this.createDate,
    required this.idModule,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) =>
      _$SensorModelFromJson(json);
  Map<String, dynamic> toJson() => _$SensorModelToJson(this);
}
