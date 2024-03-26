import 'package:generic_project/core/data/models/response/response_model.dart';

abstract class ManagerRoutesUseCase {
  Future<ResponseModel?> getRoutes(int nextPage, int pageSize);
  Future<bool> createRoute(Map<String, dynamic> routeBody);
  Future<bool> uploadRouteFile(String filePath);
}
