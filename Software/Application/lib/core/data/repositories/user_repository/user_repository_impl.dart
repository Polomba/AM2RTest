import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:generic_project/core/constants/application_constants.dart';
import 'package:generic_project/core/data/models/user/user_model.dart';
import 'package:generic_project/core/data/repositories/user_repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserModel?> registerWithEmailAndPassword(String email, String password,
      String name, String phoneNumber, String emergencyContact) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "name": name,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "emergencyContact": emergencyContact,
    });
    var dio = Dio();
    var response = await dio.request(
      ApplicationRequestPaths.usersPath,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 201) {
      log(json.encode(response.data));
      return UserModel.fromJson(response.data);
    } else {
      log(response.statusMessage ?? '');
      return null;
    }
  }

  @override
  Future<UserModel> loginWithEmailAndPassword(
      String email, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "email": email,
      "password": password,
    });
    var dio = Dio();
    var response = await dio.request(
      'api.am2r.ss-centi.com/users',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      log(json.encode(response.data));
    } else {
      log(response.statusMessage ?? '');
    }
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> deleteUser(String userId) async {
    var dio = Dio();
    var response = await dio.request(
      'api.am2r.ss-centi.com/users/$userId',
      options: Options(
        method: 'DELETE',
      ),
    );

    if (response.statusCode == 200) {
      log(json.encode(response.data));
    } else {
      log(response.statusMessage ?? '');
    }
  }

  @override
  Future<void> editUser(String userId, Map<String, dynamic> data) async {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode(data);
    var dio = Dio();
    var response = await dio.request(
      'api.am2r.ss-centi.com/users/$userId',
      options: Options(
        method: 'PATCH',
        headers: headers,
      ),
      data: body,
    );

    if (response.statusCode == 200) {
      log(json.encode(response.data));
    } else {
      log(response.statusMessage ?? '');
    }
  }

  @override
  Future<UserModel> getUser(String userId) async {
    var dio = Dio();
    var response = await dio.request(
      'api.am2r.ss-centi.com/users/$userId',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      log(json.encode(response.data));
      return UserModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}
