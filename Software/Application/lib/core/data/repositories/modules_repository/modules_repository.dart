import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:latlong2/latlong.dart';

abstract class ModulesRepository {
  Future<ResponseModel?> getModulesBetweenBounds(
      LatLng maxBounds, LatLng minBounds);

  Future<ResponseModel?> getModules(int pageNum, int pageSize);
}
