import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String token;
  final String phoneNumber;
  final bool isActive;
  final String emergencyContact;
  final String refreshToken;
  final DateTime createdAt;
  final String idLastLocation;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.createdAt,
    required this.emergencyContact,
    required this.idLastLocation,
    required this.isActive,
    required this.phoneNumber,
    required this.refreshToken,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
