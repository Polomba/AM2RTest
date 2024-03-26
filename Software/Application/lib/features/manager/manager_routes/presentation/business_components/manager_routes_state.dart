part of 'manager_routes_cubit.dart';

class ManagerRoutesInitialState extends ApplicationState {
  const ManagerRoutesInitialState();
}

class ManagerRouteFileUploadSuccessState extends ApplicationState {
  const ManagerRouteFileUploadSuccessState();
}

class ManagerCreateRouteSuccessState extends ApplicationState {
  const ManagerCreateRouteSuccessState();
}

class ManagerRoutesLoadingRoutesState extends ApplicationState {
  const ManagerRoutesLoadingRoutesState();
}

class ManagerRoutesSuccessState extends ApplicationState {
  final List<RouteModel> routes;
  final int nextPage;
  final int totalCount;
  const ManagerRoutesSuccessState({
    required this.nextPage,
    required this.routes,
    required this.totalCount,
  });
}
