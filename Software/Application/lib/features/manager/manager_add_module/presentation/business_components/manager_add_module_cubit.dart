import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/data/models/response/response_model.dart';
import 'package:generic_project/core/data/models/route/route_model.dart';
import 'package:generic_project/core/exceptions/location_exceptions.dart';
import 'package:generic_project/core/utils/location/location_service.dart';
import 'package:generic_project/features/manager/manager_add_module/domain/use_cases/manager_add_module_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'manager_add_module_state.dart';

class ManagerAddModuleCubit extends Cubit<ApplicationState> {
  final ManagerAddModuleUseCase _addModuleUseCase;
  final LocationService _locationService;
  ManagerAddModuleCubit(
      {required ManagerAddModuleUseCase addModuleUseCase,
      required LocationService locationService})
      : _addModuleUseCase = addModuleUseCase,
        _locationService = locationService,
        super(const ManagerAddModuleInitialState());

  void requestLocationPermission() async {
    try {
      final status = await _locationService.requestLocationPermission();
      emit(ManagerAddModuleLocationPermissionSuccessState(
          permissionGranted: status.isGranted));
    } catch (e) {
      _handleLocationException(e);
    }
  }

  void getCurrentLocation() async {
    try {
      emit(const ManagerAddModuleLocationLoadingState());
      final currentPosition = await _locationService.getCurrentLocation();
      if (currentPosition != null) {
        emit(ManagerAddModuleLocationSuccessState(position: currentPosition));
      } else {
        emit(const ManagerAddModuleFetchLocationFailedState());
      }
    } catch (e) {
      _handleLocationException(e);
    }
  }

  void openAppSettings() async {
    try {
      await _locationService.openAppSettings();
    } catch (e) {
      _handleLocationException(e);
    }
  }

  void _handleLocationException(e) {
    switch (e.runtimeType) {
      case LocationPermissionDeniedForeverException:
        emit(const ManagerAddModuleLocationPermissionDeniedForeverState());
        break;
      case LocationPermissionDeniedException:
        emit(const ManagerAddModuleLocationPermissionDeniedState());
        break;
      case LocationServicesDisabledException:
        emit(const ManagerAddModuleLocationServiceDisabledState());
        break;
      default:
        log(e.toString());
        emit(const ManagerAddModuleLocationUnknownExceptionState());
    }
  }

  void loadRoutes(int nextPage, int pageSize) async {
    try {
      emit(const ManagerAddModuleLoadingRoutesState());
      final ResponseModel? response =
          await _addModuleUseCase.getRoutes(nextPage, pageSize);
      final routes = response?.data.map((e) => RouteModel.fromJson(e)).toList();
      emit(
        ManagerAddModuleLoadedRoutesState(
            routes: routes ?? [],
            nextPage: (response?.page ?? 0) + 1,
            totalCount: response?.totalDocuments ?? 0),
      );
    } catch (e) {
      log(e.toString());
      emit(ApplicationApiError(message: e.toString()));
    }
  }
}
