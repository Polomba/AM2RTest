import 'package:generic_project/core/data/models/pagination/pagination_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart';

@JsonSerializable()
class ResponseModel {
  final int? page;
  @JsonKey(name: 'total_docs')
  final int? totalDocuments;
  final PaginationModel? pagination;
  final List<dynamic> data;

  ResponseModel(
      {this.page, this.totalDocuments, this.pagination, required this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
