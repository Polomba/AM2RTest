import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/repositories/modules_repository/modules_repository.dart';
import 'package:generic_project/core/data/repositories/routes_repository/routes_repository.dart';
import 'package:generic_project/features/manager/manager_add_module/domain/use_cases/manager_add_module_use_case.dart';

class ManagerAddModuleUseCaseImpl implements ManagerAddModuleUseCase {
  final ModulesRepository _modulesRepository;
  final RoutesRepository _routesRepository;
  const ManagerAddModuleUseCaseImpl(
      {required ModulesRepository modulesRepository,
      required RoutesRepository routesRepository})
      : _modulesRepository = modulesRepository,
        _routesRepository = routesRepository,
        super();

  @override
  Future<ResponseModel?> getRoutes(int nextPage, int pageSize) =>
      _routesRepository.getRoutes(nextPage, pageSize, '');
}
