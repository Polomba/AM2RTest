import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/core/enums/module_status_enum.dart';
import 'package:generic_project/core/data/models/location/location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'module_model.g.dart';

@JsonSerializable()
class ModuleModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final ModuleStatus? status;
  final LocationModel? idLocation;
  final RouteModel? idRoute;
  @JsonKey(name: 'IQAr')
  final int? iqAr;
  @JsonKey(name: 'IQArUpdate')
  final String? iqArLastUpdate;

  ModuleModel({
    this.idLocation,
    this.idRoute,
    this.id,
    this.name,
    this.status,
    this.iqAr,
    this.iqArLastUpdate,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) =>
      _$ModuleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleModelToJson(this);
}
