import 'package:dio/dio.dart';
import 'package:generic_project/core/constants/application_constants.dart';
import 'package:generic_project/core/constants/application_request_constants.dart';
import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/repositories/modules_repository/modules_repository.dart';
import 'package:latlong2/latlong.dart';

class ModulesRepositoryImpl implements ModulesRepository {
  final Dio _dio;

  const ModulesRepositoryImpl({required Dio dio})
      : _dio = dio,
        super();
  @override
  Future<ResponseModel?> getModulesBetweenBounds(
      LatLng maxBounds, LatLng minBounds) async {
    var response = await _dio.request(
      ApplicationRequestPaths.modulesBetweenBounds,
      data: {
        'minLat': minBounds.latitude,
        'minLong': minBounds.longitude,
        'maxLat': maxBounds.latitude,
        'maxLong': maxBounds.longitude,
      },
      options: Options(
        method: 'POST',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = response.data['results'];
      return ResponseModel.fromJson(jsonData);
    } else {
      return null;
    }
  }

  @override
  Future<ResponseModel?> getModules(int pageNum, int pageSize) async {
    var numPages = '${ApplicationRequestConstants.paginationPage}=$pageNum';
    var limit = '${ApplicationRequestConstants.paginationLimit}=$pageSize';
    var paramsPath = '?$numPages&$limit';

    var response = await _dio.request(
      ApplicationRequestPaths.modulesPath + paramsPath,
      options: Options(
        method: 'GET',
      ),
    );

    print(response.data);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = response.data['results'];
      return ResponseModel.fromJson(jsonData);
    } else {
      return null;
    }
  }
}
