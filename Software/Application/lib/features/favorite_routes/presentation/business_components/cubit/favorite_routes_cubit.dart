import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/favorite_routes/domain/use_cases/favorite_routes_use_case.dart';

part 'favorite_routes_state.dart';

class FavoriteRoutesCubit extends Cubit<ApplicationState> {
  final FavoriteRoutesUseCase _useCase;
  FavoriteRoutesCubit({required FavoriteRoutesUseCase favoriteRoutesUseCase})
      : _useCase = favoriteRoutesUseCase,
        super(const FavoriteRoutesInitialState());

  void removeFromFavorites(String routeId) async {
    try {
      emit(const FavoriteRoutesRemoveLoadingState());
      _useCase.removeFromFavorites(routeId);
      emit(FavoriteRoutesRemoveSuccessState(routeId: routeId));
    } catch (e) {
      emit(ApplicationApiError(message: e.toString()));
    }
  }
}