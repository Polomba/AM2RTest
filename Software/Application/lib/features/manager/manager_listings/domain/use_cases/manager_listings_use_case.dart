import 'package:generic_project/core/data/models/response/response_model.dart';

abstract class ManagerListingsUseCase {
  Future<ResponseModel?> getRoutes(int nextPage, int pageSize);

  Future<ResponseModel?> getModules(int pageNum, int pageSize);

  Future<ResponseModel?> getRouteModules(String routeId);
}
