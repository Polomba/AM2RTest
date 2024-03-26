class LocationException implements Exception {
  final String message;

  LocationException(this.message);

  @override
  String toString() => message;
}

class LocationServicesDisabledException extends LocationException {
  LocationServicesDisabledException(super.message);
}

class LocationPermissionDeniedException extends LocationException {
  LocationPermissionDeniedException(super.message);
}

class LocationPermissionDeniedForeverException extends LocationException {
  LocationPermissionDeniedForeverException(super.message);
}
