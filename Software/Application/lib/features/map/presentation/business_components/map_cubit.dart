import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/constants/application_constants.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/enums/routes_filter_type_enum.dart';
import 'package:generic_project/core/exceptions/location_exceptions.dart';
import 'package:generic_project/core/data/models/module/module_model.dart';
import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/core/utils/kml_parser/kml_utils.dart';
import 'package:generic_project/core/utils/location/location_service.dart';
import 'package:generic_project/features/map/domain/use_cases/map_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xml/xml.dart';

part 'map_state.dart';

class MapCubit extends Cubit<ApplicationState> {
  final MapUseCase _mapUseCase;
  final LocationService _locationService;
  final KMLUtility _kmlUtils;

  MapCubit({
    required MapUseCase mapUseCase,
    required LocationService locationService,
    required KMLUtility kmlUtils,
  })  : _mapUseCase = mapUseCase,
        _locationService = locationService,
        _kmlUtils = kmlUtils,
        super(const MapInitialState());

  void getModulesBetweenBounds(
      {required LatLng minBounds, required LatLng maxBounds}) async {
    try {
      emit(const MapGetModulesBetweenBoundsLoadingState());
      final responseModel = await _mapUseCase.getModulesBetweenBounds(
          minBounds: minBounds, maxBounds: maxBounds);
      if (responseModel != null) {
        final modules =
            responseModel.data.map((e) => ModuleModel.fromJson(e)).toList();
        emit(MapGetModulesBetweenBoundsSuccessState(modules: modules));
      }
    } catch (e) {
      log(e.toString());
      emit(MapGetModulesBetweenBoundsErrorState(message: e.toString()));
    }
  }

  void downloadRouteFile(String routeFileName, int fileVersion) async {
    final File? routeFile =
        await _mapUseCase.downloadRouteFile(routeFileName, fileVersion);
    if (routeFile != null && await routeFile.exists()) {
      final coordinates = _kmlUtils.getCoordinates(
        XmlDocument.parse(
          routeFile.readAsStringSync(),
        ),
      );
      emit(MapDownloadRouteFileSuccessState(routeCoordinates: coordinates));
    } else {
      emit(const ApplicationApiError(message: 'error downloading file'));
    }
  }

  void fetchFavoriteRoutes() async {
    emit(const MapFetchFavoriteRoutesLoadingState());
    final List<String> favoriteRoutes = await _mapUseCase
        .getFavoriteRoutes(ApplicationConstants.favoriteRoutesKey);
    Future.delayed(
      const Duration(seconds: 2),
      () => emit(
        MapFetchFavoriteRoutesSuccessState(favRoutes: favoriteRoutes),
      ),
    );
  }

  void removeRouteFromFavorites(String routeId) async {
    _mapUseCase.removeRouteFromFavorites(
        ApplicationConstants.favoriteRoutesKey, routeId);
    emit(MapRemoveRouteFromFavoritesSuccessState(routeId: routeId));
  }

  void addRouteToFavorites(String routeId) async {
    emit(const ApplicationLoadingState());
    _mapUseCase.addRouteToFavorites(
        ApplicationConstants.favoriteRoutesKey, routeId);
    emit(MapAddRouteToFavoritesSuccessState(routeId: routeId));
  }

  void onUserLocationChange(Position position) async {
    emit(const MapUserLocationChangeLoadingState());
    emit(MapUserLocationChangeState(position: position));
  }

  void addFilter(RoutesFilterType filter) async {
    emit(MapRouteFiltersUpdateState(filter: filter));
  }

  void showModuleInfo(ModuleModel module) {
    try {
      emit(const MapModuleInfoLoadingState());
      Future.delayed(
        const Duration(seconds: 1),
        () => emit(MapModuleInfoSuccessState(module: module)),
      );
    } catch (e) {
      _handleLocationException(e);
    }
  }

  void showRouteDetails(RouteModel route) async {
    try {
      emit(const ApplicationLoadingState());
      final responseModel = await _mapUseCase.getRouteModules(route.id);
      final List<ModuleModel> routeModules = responseModel?.data
              .map(
                (e) => ModuleModel.fromJson(e),
              )
              .toList() ??
          [];

      emit(MapShowRouteDetailsState(route: route, modules: routeModules));
    } catch (e) {
      log(e.toString());
      emit(ApplicationApiError(message: e.toString()));
    }
  }

  void getRoutes({
    int? nextPage,
    int? pageSize,
    RoutesFilterType? filterType,
  }) async {
    try {
      emit(const MapRoutesLoadingState());
      final ResponseModel? response =
          await _mapUseCase.getRoutes(nextPage ?? 1, pageSize ?? 0, filterType);
      final routes =
          response?.data.map((data) => RouteModel.fromJson(data)).toList();
      emit(MapRoutesSuccessState(
          routes: routes ?? [],
          nextPage: (response?.page ?? 0) + 1,
          totalCount: response?.totalDocuments ?? 0));
    } catch (e) {
      log('erro fetch rotas - ${e.toString()}');
      emit(ApplicationApiError(message: e.toString()));
    }
  }

  void getRouteModules(String routeId) async {
    try {
      emit(const MapModulesLoadingState());
      final responseModel = await _mapUseCase.getRouteModules(routeId);
      final List<ModuleModel> routeModules = responseModel?.data
              .map(
                (e) => ModuleModel.fromJson(e),
              )
              .toList() ??
          [];
      emit(MapModulesSuccessState(modules: routeModules));
    } catch (e) {
      log(e.toString());
      emit(const MapModulesErrorState());
    }
  }

  void requestLocationPermission() async {
    try {
      final status = await _locationService.requestLocationPermission();
      emit(MapRequestLocationPermissionSuccessState(
          permissionGranted: status.isGranted));
    } catch (e) {
      _handleLocationException(e);
    }
  }

  void getCurrentLocation() async {
    try {
      final currentPosition = await _locationService.getCurrentLocation();
      if (currentPosition != null) {
        emit(MapFetchLocationSucessState(position: currentPosition));
      } else {
        emit(const MapFetchLocationFailedState());
      }
    } catch (e) {
      _handleLocationException(e);
    }
  }

  void openAppSettings() async {
    try {
      await _locationService.openAppSettings();
    } catch (e) {
      _handleLocationException(e);
    }
  }

  void _handleLocationException(e) {
    switch (e.runtimeType) {
      case LocationPermissionDeniedForeverException:
        emit(const MapRequestLocationPermissionDeniedForeverState());
        break;
      case LocationPermissionDeniedException:
        emit(const MapRequestLocationPermissionDeniedState());
        break;
      case LocationServicesDisabledException:
        emit(const MapRequestLocationServiceDisabledState());
        break;
      default:
        log(e.toString());
        emit(const MapRequestLocationUnknownExceptionState());
    }
  }
}
