import 'package:generic_project/core/enums/event_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'module_events_model.g.dart';

@JsonSerializable()
class ModuleEventsModel {
  final String id;
  final String idModule;
  final EventType eventType;
  final DateTime createdAt;
  final DateTime finishedAt;
  final bool isActive;
  final String idLocation;

  ModuleEventsModel({
    required this.createdAt,
    required this.eventType,
    required this.finishedAt,
    required this.id,
    required this.idLocation,
    required this.idModule,
    required this.isActive,
  });

  factory ModuleEventsModel.fromJson(Map<String, dynamic> json) =>
      _$ModuleEventsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleEventsModelToJson(this);
}
