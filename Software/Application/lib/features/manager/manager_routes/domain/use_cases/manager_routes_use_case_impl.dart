import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/repositories/routes_repository/routes_repository.dart';
import 'package:generic_project/features/manager/manager_routes/domain/use_cases/manager_routes_use_case.dart';

class ManagerRoutesUseCaseImpl implements ManagerRoutesUseCase {
  final RoutesRepository _routesRepository;
  const ManagerRoutesUseCaseImpl({required RoutesRepository routesRepository})
      : _routesRepository = routesRepository;

  @override
  Future<bool> createRoute(Map<String, dynamic> routeBody) async {
    return _routesRepository.createRoute(routeBody);
  }

  @override
  Future<ResponseModel?> getRoutes(int nextPage, int pageSize) async {
    return _routesRepository.getRoutes(nextPage, pageSize, '');
  }

  @override
  Future<bool> uploadRouteFile(String filePath) async {
    return _routesRepository.uploadRouteFile(filePath);
  }
}
