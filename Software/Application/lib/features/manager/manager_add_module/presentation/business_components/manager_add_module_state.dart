part of 'manager_add_module_cubit.dart';

class ManagerAddModuleInitialState extends ApplicationState {
  const ManagerAddModuleInitialState();
}

class ManagerAddModuleLoadingRoutesState extends ApplicationState {
  const ManagerAddModuleLoadingRoutesState();
}

class ManagerAddModuleLoadedRoutesState extends ApplicationState {
  final List<RouteModel> routes;
  final int nextPage;
  final int totalCount;
  const ManagerAddModuleLoadedRoutesState(
      {required this.routes, required this.nextPage, required this.totalCount});
}

class ManagerAddModuleLocationPermissionSuccessState extends ApplicationState {
  final bool permissionGranted;
  const ManagerAddModuleLocationPermissionSuccessState(
      {required this.permissionGranted});
}

class ManagerAddModuleLocationLoadingState extends ApplicationState {
  const ManagerAddModuleLocationLoadingState();
}

class ManagerAddModuleLocationSuccessState extends ApplicationState {
  final Position position;
  const ManagerAddModuleLocationSuccessState({required this.position});
}

class ManagerAddModuleFetchLocationFailedState extends ApplicationState {
  const ManagerAddModuleFetchLocationFailedState();
}

class ManagerAddModuleLocationPermissionDeniedForeverState
    extends ApplicationState {
  const ManagerAddModuleLocationPermissionDeniedForeverState();
}

class ManagerAddModuleLocationPermissionDeniedState extends ApplicationState {
  const ManagerAddModuleLocationPermissionDeniedState();
}

class ManagerAddModuleLocationServiceDisabledState extends ApplicationState {
  const ManagerAddModuleLocationServiceDisabledState();
}

class ManagerAddModuleLocationUnknownExceptionState extends ApplicationState {
  const ManagerAddModuleLocationUnknownExceptionState();
}
