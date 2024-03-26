// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      page: json['page'] as int?,
      totalDocuments: json['total_docs'] as int?,
      pagination: json['pagination'] == null
          ? null
          : PaginationModel.fromJson(
              json['pagination'] as Map<String, dynamic>),
      data: json['data'] as List<dynamic>,
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total_docs': instance.totalDocuments,
      'pagination': instance.pagination,
      'data': instance.data,
    };
