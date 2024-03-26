part of 'favorite_routes_cubit.dart';

class FavoriteRoutesInitialState extends ApplicationState {
  const FavoriteRoutesInitialState();
}

class FavoriteRoutesLoadingState extends ApplicationState {
  const FavoriteRoutesLoadingState();
}

class FavoriteRoutesSuccessState extends ApplicationState {
  final List<RouteModel> favRoutes;
  const FavoriteRoutesSuccessState({required this.favRoutes});
}

class FavoriteRoutesRemoveLoadingState extends ApplicationState {
  const FavoriteRoutesRemoveLoadingState();
}

class FavoriteRoutesRemoveSuccessState extends ApplicationState {
  final String routeId;
  const FavoriteRoutesRemoveSuccessState({required this.routeId});
}
