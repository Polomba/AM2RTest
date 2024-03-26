import 'dart:developer';

import 'package:generic_project/core/exceptions/location_exceptions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    final status = await requestLocationPermission();
    if (status.isGranted) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } else {
      throw LocationException('Unable to fetch location');
    }
  }

  Future<PermissionStatus> requestLocationPermission() async {
    final isGPSEnabled = await _isLocationServiceEnabled();
    if (!isGPSEnabled) {
      throw LocationServicesDisabledException('Location service disabled');
    } else {
      final status = await Permission.location.request();

      if (status.isGranted) {
        log('Location permission granted!');
        return status;
      } else if (status.isDenied) {
        throw LocationPermissionDeniedException(
            'Location permission is denied');
      } else if (status.isPermanentlyDenied) {
        //openAppSettings(); // Open the app settings to allow the user to grant permission.
        throw LocationPermissionDeniedForeverException(
            'Location permission is permanently denied');
      }
      return status;
    }
  }

  Future<bool> _isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
