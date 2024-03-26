import 'dart:io';

import 'package:generic_project/core/constants/application_request_constants.dart';
import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/repositories/modules_repository/modules_repository.dart';
import 'package:generic_project/core/data/repositories/routes_repository/routes_repository.dart';
import 'package:generic_project/core/enums/routes_filter_type_enum.dart';
import 'package:generic_project/features/map/domain/use_cases/map_use_case.dart';
import 'package:latlong2/latlong.dart';

class MapUseCaseImpl implements MapUseCase {
  final RoutesRepository _routesRepository;
  final ModulesRepository _modulesRepository;
  const MapUseCaseImpl(
      {required RoutesRepository routesRepository,
      required ModulesRepository modulesRepository})
      : _routesRepository = routesRepository,
        _modulesRepository = modulesRepository;

  @override
  Future<ResponseModel?> getModulesBetweenBounds(
          {required LatLng minBounds, required LatLng maxBounds}) async =>
      _modulesRepository.getModulesBetweenBounds(maxBounds, minBounds);

  @override
  Future<ResponseModel?> getRouteModules(String routeId) async =>
      _routesRepository.getRouteModules(routeId);

  @override
  Future<ResponseModel?> getRoutes(
      int nextPage, int pageSize, RoutesFilterType? filterType) async {
    var filtersString = '?';
    switch (filterType) {
      case RoutesFilterType.distance:
        filtersString +=
            '${ApplicationRequestConstants.sortByAscending}${ApplicationRequestConstants.routeDistance}';
        break;
      case RoutesFilterType.iqar:
        filtersString +=
            '${ApplicationRequestConstants.sortByDescending}${ApplicationRequestConstants.routeIqar}';
        break;
      case RoutesFilterType.numOfOccurrences:
        filtersString +=
            '${ApplicationRequestConstants.sortByAscending}${ApplicationRequestConstants.routeTotalEvents}';
        break;
      case RoutesFilterType.traffic:
        filtersString +=
            '${ApplicationRequestConstants.sortByAscending}${ApplicationRequestConstants.routeTotalPeople}';
        break;
      default:
        filtersString = '?';
        break;
    }
    return _routesRepository.getRoutes(nextPage, pageSize, filtersString);
  }

  @override
  Future<void> addRouteToFavorites(String tokenKey, String idRoute) =>
      _routesRepository.addRouteToFavorites(tokenKey, idRoute);

  @override
  Future<List<String>> getFavoriteRoutes(String tokenKey) =>
      _routesRepository.getFavoriteRoutes(tokenKey);

  @override
  Future<void> removeRouteFromFavorites(String tokenKey, String idRoute) =>
      _routesRepository.removeRouteFromFavorites(tokenKey, idRoute);

  @override
  Future<File?> downloadRouteFile(String fileName, int fileVersion) async =>
      await _routesRepository.downloadRouteFile(fileName, fileVersion);
}
