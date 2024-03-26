import 'dart:io';

import 'package:generic_project/core/data/models/response/response_model.dart';

abstract class RoutesRepository {
  Future<ResponseModel?> getRoutes(int nextPage, int pageSize, String filters);
  Future<ResponseModel?> getRouteModules(String routeId);
  Future<void> addRouteToFavorites(String tokenKey, String idRoute);
  Future<void> removeRouteFromFavorites(String tokenKey, String idRoute);
  Future<List<String>> getFavoriteRoutes(String tokenKey);
  Future<File?> downloadRouteFile(String fileName, int fileVersion);
  Future<bool> uploadRouteFile(String filePath);
  Future<bool> createRoute(Map<String, dynamic> route);
}
