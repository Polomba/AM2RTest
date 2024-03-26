import 'package:generic_project/core/constants/application_constants.dart';
import 'package:generic_project/core/data/repositories/routes_repository/routes_repository.dart';
import 'package:generic_project/features/favorite_routes/domain/use_cases/favorite_routes_use_case.dart';

class FavoriteRoutesUseCaseImpl implements FavoriteRoutesUseCase {
  final RoutesRepository _routesRepository;
  const FavoriteRoutesUseCaseImpl({required RoutesRepository routesRepository})
      : _routesRepository = routesRepository,
        super();

  @override
  Future<void> removeFromFavorites(String routeId) async {
    _routesRepository.removeRouteFromFavorites(
        ApplicationConstants.favoriteRoutesKey, routeId);
  }
}
