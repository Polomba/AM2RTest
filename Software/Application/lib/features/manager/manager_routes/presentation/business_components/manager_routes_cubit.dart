import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/features/manager/manager_routes/domain/use_cases/manager_routes_use_case.dart';

part 'manager_routes_state.dart';

class ManagerRoutesCubit extends Cubit<ApplicationState> {
  final ManagerRoutesUseCase _routesUseCase;
  ManagerRoutesCubit({required ManagerRoutesUseCase routesUseCase})
      : _routesUseCase = routesUseCase,
        super(const ManagerRoutesInitialState());

  void uploadRouteFile(String filePath) async {
    try {
      final didUpload = await _routesUseCase.uploadRouteFile(filePath);
      if (didUpload) {
        emit(const ManagerRouteFileUploadSuccessState());
      }
    } catch (e) {
      log('erro upload ficheiro - ${e.toString()}');
      emit(ApplicationApiError(message: e.toString()));
    }
  }

  void createRoute(Map<String, dynamic> routeBody) async {
    try {
      emit(const ApplicationLoadingState());
      final isCreated = await _routesUseCase.createRoute(routeBody);
      if (isCreated) {
        emit(const ManagerCreateRouteSuccessState());
      }
    } catch (e) {
      log('erro criar rota - ${e.toString()}');
      emit(ApplicationApiError(message: e.toString()));
    }
  }

  void getRoutes({
    int? nextPage,
    int? pageSize,
  }) async {
    try {
      emit(const ManagerRoutesLoadingRoutesState());
      final ResponseModel? response = await _routesUseCase.getRoutes(
        nextPage ?? 1,
        pageSize ?? 0,
      );
      final routes =
          response?.data.map((data) => RouteModel.fromJson(data)).toList();
      emit(ManagerRoutesSuccessState(
          routes: routes ?? [],
          nextPage: (response?.page ?? 0) + 1,
          totalCount: response?.totalDocuments ?? 0));
    } catch (e) {
      log('erro fetch rotas - ${e.toString()}');
      emit(ApplicationApiError(message: e.toString()));
    }
  }
}
