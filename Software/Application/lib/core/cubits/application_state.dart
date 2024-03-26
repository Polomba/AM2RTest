import 'package:equatable/equatable.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object> get props => [];
}

class ApplicationInitialState extends ApplicationState {
  const ApplicationInitialState();
}

class ApplicationLoadingState extends ApplicationState {
  const ApplicationLoadingState();
}

class ApplicationErrorState extends ApplicationState {
  final String message;

  const ApplicationErrorState({required this.message});
}

class ApplicationApiError extends ApplicationErrorState {
  const ApplicationApiError({required String message})
      : super(message: message);
}

class ApplicationNoInternetError extends ApplicationErrorState {
  const ApplicationNoInternetError({required String message})
      : super(message: message);
}
