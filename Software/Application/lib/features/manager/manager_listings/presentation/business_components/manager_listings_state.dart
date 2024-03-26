part of 'manager_listings_cubit.dart';

class ManagerListingsInitialState extends ApplicationState {
  const ManagerListingsInitialState();
}

class ManagerListingsRoutesSuccessState extends ApplicationState {
  final List<RouteModel> routes;

  final int nextPage;
  final int totalCount;
  const ManagerListingsRoutesSuccessState(
      {required this.routes, required this.nextPage, required this.totalCount});
}

class ManagerListingsModulesSuccessState extends ApplicationState {
  final List<ModuleModel> modules;

  final int nextPage;
  final int totalCount;
  const ManagerListingsModulesSuccessState(
      {required this.modules,
      required this.nextPage,
      required this.totalCount});
}

class ManagerListingsRouteDetailsModulesSuccessState extends ApplicationState {
  final List<ModuleModel> modules;
  const ManagerListingsRouteDetailsModulesSuccessState({required this.modules});
}
