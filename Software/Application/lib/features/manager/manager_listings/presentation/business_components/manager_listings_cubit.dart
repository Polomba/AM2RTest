import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/data/models/module/module_model.dart';
import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/manager/manager_listings/domain/use_cases/manager_listings_use_case.dart';

part 'manager_listings_state.dart';

class ManagerListingsCubit extends Cubit<ApplicationState> {
  final ManagerListingsUseCase _listingsUseCase;
  ManagerListingsCubit({required ManagerListingsUseCase listingsUseCase})
      : _listingsUseCase = listingsUseCase,
        super(const ManagerListingsInitialState());

  void getRoutes(int nextPage, int pageSize) async {
    try {
      emit(const ApplicationLoadingState());

      final ResponseModel? response =
          await _listingsUseCase.getRoutes(nextPage, pageSize);
      final List<RouteModel> routes =
          response?.data.map((e) => RouteModel.fromJson(e)).toList() ?? [];
      emit(
        ManagerListingsRoutesSuccessState(
            routes: routes,
            nextPage: (response?.page ?? 0) + 1,
            totalCount: response?.totalDocuments ?? 0),
      );
    } catch (e) {
      log(e.toString());
      emit(
        ApplicationApiError(
          message: e.toString(),
        ),
      );
    }
  }

  void getModules(int pageNum, int pageSize) async {
    try {
      emit(const ApplicationLoadingState());

      final ResponseModel? response =
          await _listingsUseCase.getModules(pageNum, pageSize);
      final List<ModuleModel> modules =
          response?.data.map((e) => ModuleModel.fromJson(e)).toList() ?? [];
      emit(
        ManagerListingsModulesSuccessState(
            modules: modules,
            nextPage: (response?.page ?? 0) + 1,
            totalCount: response?.totalDocuments ?? 0),
      );
    } catch (e) {
      log(e.toString());
      emit(
        ApplicationApiError(
          message: e.toString(),
        ),
      );
    }
  }

  void getRouteModules(String routeId) async {
    try {
      emit(const ApplicationLoadingState());
      final ResponseModel? response =
          await _listingsUseCase.getRouteModules(routeId);
      emit(ManagerListingsRouteDetailsModulesSuccessState(
          modules:
              response?.data.map((e) => ModuleModel.fromJson(e)).toList() ??
                  []));
    } catch (e) {
      log(e.toString());
      emit(ApplicationApiError(message: e.toString()));
    }
  }
}
