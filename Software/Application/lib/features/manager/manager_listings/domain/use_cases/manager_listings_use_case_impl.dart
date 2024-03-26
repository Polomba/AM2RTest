import 'package:generic_project/core/constants/application_request_constants.dart';
import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/repositories/modules_repository/modules_repository.dart';
import 'package:generic_project/core/data/repositories/routes_repository/routes_repository.dart';
import 'package:generic_project/features/manager/manager_listings/domain/use_cases/manager_listings_use_case.dart';

class ManagerListingsUseCaseImpl implements ManagerListingsUseCase {
  final RoutesRepository _routesRepository;
  final ModulesRepository _modulesRepository;
  const ManagerListingsUseCaseImpl(
      {required RoutesRepository routesRepository,
      required ModulesRepository modulesRepository})
      : _routesRepository = routesRepository,
        _modulesRepository = modulesRepository,
        super();

  @override
  Future<ResponseModel?> getRoutes(int nextPage, int pageSize) =>
      _routesRepository.getRoutes(nextPage, pageSize,
          '?${ApplicationRequestConstants.sortByDescending}${ApplicationRequestConstants.routeTotalEvents}');

  @override
  Future<ResponseModel?> getModules(int pageNum, int pageSize) =>
      _modulesRepository.getModules(pageNum, pageSize);

  @override
  Future<ResponseModel?> getRouteModules(String routeId) =>
      _routesRepository.getRouteModules(routeId);
}
