// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      emergencyContact: json['emergencyContact'] as String,
      idLastLocation: json['idLastLocation'] as String,
      isActive: json['isActive'] as bool,
      phoneNumber: json['phoneNumber'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'token': instance.token,
      'phoneNumber': instance.phoneNumber,
      'isActive': instance.isActive,
      'emergencyContact': instance.emergencyContact,
      'refreshToken': instance.refreshToken,
      'createdAt': instance.createdAt.toIso8601String(),
      'idLastLocation': instance.idLastLocation,
    };
