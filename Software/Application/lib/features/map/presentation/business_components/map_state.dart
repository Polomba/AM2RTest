part of 'map_cubit.dart';

class MapInitialState extends ApplicationState {
  const MapInitialState();
}

class MapShowRouteDetailsState extends ApplicationState {
  final RouteModel route;
  final List<ModuleModel> modules;
  const MapShowRouteDetailsState({required this.route, required this.modules});
}

class MapGetModulesBetweenBoundsLoadingState extends ApplicationState {
  const MapGetModulesBetweenBoundsLoadingState();
}

class MapGetModulesBetweenBoundsErrorState extends ApplicationErrorState {
  const MapGetModulesBetweenBoundsErrorState({required super.message});
}

class MapGetModulesBetweenBoundsSuccessState extends ApplicationState {
  final List<ModuleModel> modules;
  const MapGetModulesBetweenBoundsSuccessState({required this.modules});
}

class MapDownloadRouteFileSuccessState extends ApplicationState {
  final List<Map<String, double>> routeCoordinates;
  const MapDownloadRouteFileSuccessState({required this.routeCoordinates});
}

class MapFetchFavoriteRoutesSuccessState extends ApplicationState {
  final List<String> favRoutes;
  const MapFetchFavoriteRoutesSuccessState({required this.favRoutes});
}

class MapFetchFavoriteRoutesLoadingState extends ApplicationState {
  const MapFetchFavoriteRoutesLoadingState();
}

class MapAddRouteToFavoritesSuccessState extends ApplicationState {
  final String routeId;
  const MapAddRouteToFavoritesSuccessState({required this.routeId});
}

class MapRemoveRouteFromFavoritesSuccessState extends ApplicationState {
  final String routeId;
  const MapRemoveRouteFromFavoritesSuccessState({required this.routeId});
}

class MapUserLocationChangeLoadingState extends ApplicationState {
  const MapUserLocationChangeLoadingState();
}

class MapUserLocationChangeState extends ApplicationState {
  final Position position;
  const MapUserLocationChangeState({required this.position});
}

class MapModuleInfoLoadingState extends ApplicationState {
  const MapModuleInfoLoadingState();
}

class MapModuleInfoSuccessState extends ApplicationState {
  final ModuleModel module;
  const MapModuleInfoSuccessState({required this.module});
}

class MapRoutesLoadingState extends ApplicationState {
  const MapRoutesLoadingState();
}

class MapRoutesSuccessState extends ApplicationState {
  final List<RouteModel> routes;
  final int nextPage;
  final int totalCount;
  const MapRoutesSuccessState(
      {required this.routes, required this.nextPage, required this.totalCount});
}

class MapModulesLoadingState extends ApplicationState {
  const MapModulesLoadingState();
}

class MapModulesSuccessState extends ApplicationState {
  final List<ModuleModel> modules;
  const MapModulesSuccessState({required this.modules});
}

class MapModulesErrorState extends ApplicationState {
  const MapModulesErrorState();
}

class MapFetchLocationSucessState extends ApplicationState {
  final Position position;
  const MapFetchLocationSucessState({required this.position});
}

class MapFetchLocationFailedState extends ApplicationState {
  const MapFetchLocationFailedState();
}

class MapRequestLocationPermissionSuccessState extends ApplicationState {
  final bool permissionGranted;
  const MapRequestLocationPermissionSuccessState(
      {required this.permissionGranted});
}

class MapRequestLocationPermissionDeniedState extends ApplicationState {
  const MapRequestLocationPermissionDeniedState();
}

class MapRequestLocationPermissionDeniedForeverState extends ApplicationState {
  const MapRequestLocationPermissionDeniedForeverState();
}

class MapRequestLocationServiceDisabledState extends ApplicationState {
  const MapRequestLocationServiceDisabledState();
}

class MapRequestLocationUnknownExceptionState extends ApplicationState {
  const MapRequestLocationUnknownExceptionState();
}

class MapRouteFiltersUpdateState extends ApplicationState {
  final RoutesFilterType filter;
  const MapRouteFiltersUpdateState({required this.filter});
}
