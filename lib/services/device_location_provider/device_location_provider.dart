import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceLocationProvider {
  static const int _refreshDistance = 5;

  static Position? refreshPosition;
  Position? _position;

  static StreamSubscription<Position>? positionStream;

  final StreamController<Position> _refreshPositionStreamController =
      StreamController<Position>();
  Stream<Position> get refreshPositionStream =>
      _refreshPositionStreamController.stream;

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
        refreshPosition = _position;
        startLocationListener(refreshPostion: refreshPosition!);
      } catch (e) {
        throw Exception('Error fetching device current position: $e');
      }
    }
  }

  void startLocationListener({required Position refreshPostion}) {
    double _distance;

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen(
      (position) {
        _distance = Geolocator.distanceBetween(refreshPostion.latitude,
            refreshPostion.longitude, position.latitude, position.longitude);
        if (_distance > _refreshDistance) {
          _refreshPositionStreamController.add(position);
          refreshPosition = position;
        }
      },
    );
  }
}
