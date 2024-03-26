import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:generic_project/core/data/repositories/location_repository/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<void> createLocation(Map<String, dynamic> data) async {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode(data);
    var dio = Dio();
    var response = await dio.request(
      'api.am2r.ss-centi.com/location',
      options: Options(
        method: 'POST',
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
}
