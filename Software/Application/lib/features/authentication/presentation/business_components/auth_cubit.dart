import 'dart:developer';

import 'package:generic_project/core/data/repositories/user_repository/user_repository.dart';
import 'package:generic_project/core/services/shared_prefs_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/cubits/application_state.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<ApplicationState> {
  final UserRepository _userRepository;
  AuthCubit(
      {required SharedPrefsService authService,
      required UserRepository userRepository})
      : _authService = authService,
        _userRepository = userRepository,
        super(const AuthInitialState());

  final SharedPrefsService _authService;

  void checkAuthentication() async {
    try {
      final jwtToken = await _authService.getToken('jwt_token');
      if (jwtToken != null) {
        emit(const AuthAuthenticatedState());
      } else {
        emit(const AuthUnauthenticatedState());
      }
    } catch (e) {
      log(e.toString());
      emit(ApplicationApiError(message: e.toString()));
    }
  }

  void loginWithEmailAndPassword(bool keepMeLoggedIn, String email, String password) {
    try {
      emit(const ApplicationLoadingState());
      _userRepository.loginWithEmailAndPassword(email, password);
      if (keepMeLoggedIn) {
        _authService.storeToken('jwt_token', 'token');
      }
      emit(const AuthAuthenticatedState());
    } catch (e) {
      log(
        e.toString(),
      );
      emit(
        ApplicationApiError(
          message: e.toString(),
        ),
      );
    }
  }
}
