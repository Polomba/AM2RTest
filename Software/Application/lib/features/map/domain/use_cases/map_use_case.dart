import 'dart:io';

import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/enums/routes_filter_type_enum.dart';
import 'package:latlong2/latlong.dart';

abstract class MapUseCase {
  Future<ResponseModel?> getRoutes(
      int nextPage, int pageSize, RoutesFilterType? filterType);
  Future<ResponseModel?> getRouteModules(String routeId);
  Future<void> addRouteToFavorites(String tokenKey, String idRoute);
  Future<void> removeRouteFromFavorites(String tokenKey, String idRoute);
  Future<List<String>> getFavoriteRoutes(
    String tokenKey,
  );
  Future<File?> downloadRouteFile(String fileName, int fileVersion);
  Future<ResponseModel?> getModulesBetweenBounds(
      {required LatLng minBounds, required LatLng maxBounds});
}
