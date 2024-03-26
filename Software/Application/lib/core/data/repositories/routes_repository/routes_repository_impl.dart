import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:generic_project/core/constants/application_constants.dart';
import 'package:generic_project/core/constants/application_request_constants.dart';
import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/repositories/routes_repository/routes_repository.dart';
import 'package:generic_project/core/services/shared_prefs_service.dart';
import 'package:path_provider/path_provider.dart';

class RoutesRepositoryImpl implements RoutesRepository {
  final Dio _dio;
  final SharedPrefsService _sharedPrefsService;
  const RoutesRepositoryImpl(
      {required Dio dio, required SharedPrefsService sharedPrefsService})
      : _dio = dio,
        _sharedPrefsService = sharedPrefsService,
        super();

  @override
  Future<bool> createRoute(Map<String, dynamic> route) async {
    var response = await _dio.request(
      ApplicationRequestPaths.routesPath,
      options: Options(method: 'POST', headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NTc2Zjg2YzIxZjQ1YTAwMTc2NmQ3NjUiLCJpc3MiOiJhbTJyLXNlcnZlciIsImlhdCI6MTcwMjI5NTczMywiZXhwIjoxNzAyMjk2NjMzfQ.7KNGAEUgSU_ugCdwQaz91UBFla0UGshHeyAq0S63cBM'
      }),
      data: json.encode(route),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      log(response.statusMessage ?? '');
      return false;
    }
  }

  @override
  Future<ResponseModel?> getRoutes(
      int nextPage, int pageSize, String filters) async {
    var numPages = '${ApplicationRequestConstants.paginationPage}=$nextPage';
    var limit = '${ApplicationRequestConstants.paginationLimit}=$pageSize';
    var paramsPath = '';
    if (filters != '') {
      paramsPath = '$filters&$numPages&$limit';
    } else {
      paramsPath = '?$numPages&$limit';
    }
    var response = await _dio.request(
      ApplicationRequestPaths.routesPath + paramsPath,
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = response.data['results'];

      return ResponseModel.fromJson(jsonData);
    } else {
      log(response.statusMessage ?? '');
    }
    return null;
  }

  @override
  Future<ResponseModel?> getRouteModules(String routeId) async {
    var response = await _dio.request(
      '${ApplicationRequestPaths.modulesByRouteId}/$routeId',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      return ResponseModel.fromJson(response.data['results']);
    } else {
      log(response.statusMessage ?? '');
    }
    return null;
  }

  @override
  Future<void> addRouteToFavorites(String tokenKey, String idRoute) async =>
      await _sharedPrefsService.storeTokenList(tokenKey, idRoute);

  @override
  Future<List<String>> getFavoriteRoutes(String tokenKey) async =>
      await _sharedPrefsService.getTokenList(tokenKey);

  @override
  Future<void> removeRouteFromFavorites(
          String tokenKey, String idRoute) async =>
      await _sharedPrefsService.removeFromList(tokenKey, idRoute);

  @override
  Future<File?> downloadRouteFile(String fileName, int fileVersion) async {
    var directory = await getApplicationDocumentsDirectory();
    final existingFilename = fileName.split('_')[0];

    try {
      var existingFile = directory.listSync().firstWhere(
            (element) => element.path.contains(existingFilename),
          );

      if (await existingFile.exists()) {
        // Extract the version number from the existing file name using a regex
        var match = RegExp(r'_v(\d+)\.kml').firstMatch(existingFile.path);
        var existingFileVersion =
            match != null ? int.tryParse(match.group(1)!) : null;

        if (existingFileVersion != fileVersion) {
          // Delete the file if the version is not the expected one
          await existingFile.delete();
          log('Deleted outdated file...');
        } else {
          log('loading existing file...');
          return File(existingFile.path);
        }
      }
    } catch (e) {
      log('no file found...');
    }

    // If no file exists, proceeds to download the latest version
    var headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NTc2Zjg2YzIxZjQ1YTAwMTc2NmQ3NjUiLCJpc3MiOiJhbTJyLXNlcnZlciIsImlhdCI6MTcwMjI5NTczMywiZXhwIjoxNzAyMjk2NjMzfQ.7KNGAEUgSU_ugCdwQaz91UBFla0UGshHeyAq0S63cBM'
    };
    final url = '${ApplicationRequestPaths.fileSystemDownloadFile}/$fileName';
    var response = await _dio.request(
      url,
      options: Options(
        headers: headers,
        method: 'GET',
      ),
    );
    if (response.statusCode == 200) {
      log('saving file...');
      var routeFile = File('${directory.path}/$fileName');
      await routeFile.writeAsString(response.data);
      return routeFile;
    } else if (response.statusCode == 403) {}

    return null;
  }

  @override
  Future<bool> uploadRouteFile(String filePath) async {
    var headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NTc2Zjg2YzIxZjQ1YTAwMTc2NmQ3NjUiLCJpc3MiOiJhbTJyLXNlcnZlciIsImlhdCI6MTcwMjI5NTczMywiZXhwIjoxNzAyMjk2NjMzfQ.7KNGAEUgSU_ugCdwQaz91UBFla0UGshHeyAq0S63cBM'
    };
    var data = FormData.fromMap({
      'files': [await MultipartFile.fromFile(filePath)],
    });

    var response = await _dio.request(
      ApplicationRequestPaths.fileSystemUploadFile,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      log(json.encode(response.data));
      return true;
    } else {
      log(response.statusMessage ?? '');
      return false;
    }
  }
}
