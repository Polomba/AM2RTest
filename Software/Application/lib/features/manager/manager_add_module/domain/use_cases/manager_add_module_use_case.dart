import 'package:generic_project/core/data/models/response/response_model.dart';

abstract class ManagerAddModuleUseCase {
  Future<ResponseModel?> getRoutes(int nextPage, int pageSize);
}
