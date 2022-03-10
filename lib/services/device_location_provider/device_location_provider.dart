import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceLocationProvider extends ChangeNotifier {
  Position? _refreshPosition;
  Position? _position;
  Position? get position => _position;

  // ignore: unused_field

  Future<void> initDeviceLocationProvider() async {
    final permissionStatus = await Permission.location.status;

    if (!permissionStatus.isGranted) {
      try {
        await Permission.locationWhenInUse.request();
      } catch (e) {
        throw Exception(
            'Something went wrong with device location permission: $e');
      }
    }

    if (permissionStatus.isGranted || permissionStatus.isLimited) {
      try {
        _position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        _refreshPosition = _position;
        _startLocationListener();
      } catch (e) {
        throw Exception('Error fetching device current position: $e');
      }
    }
  }

  void _startLocationListener() {
    // ignore: TODO: create getter to handle stream, unused_local_variable
    final StreamSubscription<Position> _positionStream;
    double _distance;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen(
      (position) {
        _distance = Geolocator.distanceBetween(_refreshPosition!.latitude,
            _refreshPosition!.longitude, position.latitude, position.longitude);
        if (_distance > 2) {
          _position = position;
          _refreshPosition = position;
          notifyListeners();
        }
      },
    );
  }
}
