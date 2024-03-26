import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/cubits/application_state.dart';
import 'package:generic_project/core/data/repositories/user_repository/user_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<ApplicationState> {
  final UserRepository _userRepository;
  RegisterCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const RegisterInitialState());

  void registerWithEmailAndPassword(
      {required String name,
      required String email,
      required String password,
      required String phoneNumber,
      required String emergencyContact}) async {
    try {
      emit(const RegisterLoadingState());
      final user = await _userRepository.registerWithEmailAndPassword(
          name, email, password, phoneNumber, emergencyContact);
      if (user != null) {
        emit(const RegisterSuccessState());
      } else {
        emit(const RegisterFailedState());
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
