import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceLocationProvider {
  static const int _refreshDistance = 5;

  Position? _refreshPosition;
  Position? get refreshPosition => _refreshPosition;
  Position? _position;

  StreamSubscription<Position>? _positionStream;
  StreamSubscription<Position>? get positionStream => _positionStream;

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
        _refreshPosition = _position;
        _startLocationListener();
      } catch (e) {
        throw Exception('Error fetching device current position: $e');
      }
    }
  }

  void _startLocationListener() {
    double _distance;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen(
      (position) {
        _distance = Geolocator.distanceBetween(_refreshPosition!.latitude,
            _refreshPosition!.longitude, position.latitude, position.longitude);
        //print(_distance);
        if (_distance > _refreshDistance) {
          _refreshPositionStreamController.add(position);
          _refreshPosition = position;
        }
      },
    );
  }
}
