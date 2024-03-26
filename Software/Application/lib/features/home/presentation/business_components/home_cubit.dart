import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_project/core/cubits/application_state.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<ApplicationState> {
  HomeCubit() : super(const HomeInitialState());
}
