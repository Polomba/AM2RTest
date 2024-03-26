import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationCubitObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    developer.log('onChange --- bloc: ${bloc.runtimeType}, change: $change');
  }
}
