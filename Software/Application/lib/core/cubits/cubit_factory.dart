import 'package:dio/dio.dart';
import 'package:generic_project/core/data/repositories/modules_repository/modules_repository_impl.dart';
import 'package:generic_project/core/data/repositories/routes_repository/routes_repository_impl.dart';
import 'package:generic_project/core/utils/kml_parser/kml_utils.dart';
import 'package:generic_project/features/authentication/presentation/business_components/auth_cubit.dart';
import 'package:generic_project/features/favorite_routes/domain/use_cases/favorite_routes_use_case_impl.dart';
import 'package:generic_project/features/favorite_routes/presentation/business_components/cubit/favorite_routes_cubit.dart';
import 'package:generic_project/features/home/presentation/business_components/home_cubit.dart';
import 'package:generic_project/features/manager/manager_add_module/domain/use_cases/manager_add_module_use_case_impl.dart';
import 'package:generic_project/features/manager/manager_add_module/presentation/business_components/manager_add_module_cubit.dart';

import 'package:generic_project/features/manager/manager_listings/domain/use_cases/manager_listings_use_case_impl.dart';
import 'package:generic_project/features/manager/manager_listings/presentation/business_components/manager_listings_cubit.dart';

import 'package:generic_project/features/manager/manager_routes/domain/use_cases/manager_routes_use_case_impl.dart';
import 'package:generic_project/features/manager/manager_routes/presentation/business_components/manager_routes_cubit.dart';
import 'package:generic_project/features/map/domain/use_cases/map_use_case_impl.dart';
import 'package:generic_project/features/map/presentation/business_components/map_cubit.dart';
import 'package:generic_project/core/data/repositories/user_repository/user_repository_impl.dart';
import 'package:generic_project/core/services/shared_prefs_service.dart';
import 'package:generic_project/core/utils/location/location_service.dart';
import 'package:generic_project/features/register/presentation/business_components/register_cubit.dart';

class CubitFactory {
  static final Dio _dio = Dio();
  static final LocationService _locationService = LocationService();
  static final SharedPrefsService _sharedPrefsService = SharedPrefsService();
  static final KMLUtility _kmlUtility = KMLUtility();

  static FavoriteRoutesCubit get favoriteRoutesCubit => FavoriteRoutesCubit(
        favoriteRoutesUseCase: FavoriteRoutesUseCaseImpl(
          routesRepository: RoutesRepositoryImpl(
              dio: _dio, sharedPrefsService: _sharedPrefsService),
        ),
      );
  static AuthCubit get authCubit => AuthCubit(
      authService: _sharedPrefsService, userRepository: UserRepositoryImpl());
  static HomeCubit get homeCubit => HomeCubit();
  static RegisterCubit get registerCubit =>
      RegisterCubit(userRepository: UserRepositoryImpl());

  static MapCubit get mapCubit => MapCubit(
        mapUseCase: MapUseCaseImpl(
          routesRepository: RoutesRepositoryImpl(
              dio: _dio, sharedPrefsService: _sharedPrefsService),
          modulesRepository: ModulesRepositoryImpl(dio: _dio),
        ),
        kmlUtils: _kmlUtility,
        locationService: _locationService,
      );

  static ManagerRoutesCubit get managerRoutesCubit => ManagerRoutesCubit(
        routesUseCase: ManagerRoutesUseCaseImpl(
          routesRepository: RoutesRepositoryImpl(
              dio: _dio, sharedPrefsService: _sharedPrefsService),
        ),
      );
  static ManagerListingsCubit get managerListingsCubit => ManagerListingsCubit(
        listingsUseCase: ManagerListingsUseCaseImpl(
            routesRepository: RoutesRepositoryImpl(
                dio: _dio, sharedPrefsService: _sharedPrefsService),
            modulesRepository: ModulesRepositoryImpl(dio: _dio)),
      );

  static ManagerAddModuleCubit get managerAddModuleCubit =>
      ManagerAddModuleCubit(
        locationService: _locationService,
        addModuleUseCase: ManagerAddModuleUseCaseImpl(
          modulesRepository: ModulesRepositoryImpl(dio: _dio),
          routesRepository: RoutesRepositoryImpl(
              dio: _dio, sharedPrefsService: _sharedPrefsService),
        ),
      );
}
