import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceLocationProvider extends ChangeNotifier {
  Position? _refreshPosition;
  Position? _position;
  Position? get position => _position;

  late StreamSubscription<Position> _positionStream;

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
        print('Hier');
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
        print(_distance);
        if (_distance > 5) {
          _position = position;
          notifyListeners();
          print('Refresh now');
        }
      },
    );
  }

  // Future<Position?> getCurrentPosition() async {
  //   Position? _position;

  //   if (permissionStatus.isGranted || permissionStatus.isLimited) {
  //     try {
  //       _position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //     } catch (e) {
  //       throw Exception('Error fetching device current position: $e');
  //     }
  //   }

  //   return _position;
  // }

  // _startPosition = await DeviceLocation().getCurrentPosition();
  //   double _distance;
  //
  //   if (_startPosition != null) {
  //     StreamSubscription<Position> _positionStream =
  //         Geolocator.getPositionStream(
  //                 locationSettings:
  //                     LocationSettings(accuracy: LocationAccuracy.high))
  //             .listen(
  //       (position) async {
  //         _distance = Geolocator.distanceBetween(_startPosition!.latitude,
  //             _startPosition!.longitude, position.latitude, position.longitude);
  //         print(_distance);
  //         if (_distance > 5) {
  //           await _getParkingList(position: position);
  //           print('Refresh now');
  //         }
  //       },
  //       onDone: () => print('onDone'),
  //     );
  //     // _positionStream.listen(
  //     //   (position) {
  //     //     _distance = Geolocator.distanceBetween(_startPosition!.latitude,
  //     //         _startPosition!.longitude, position.latitude, position.longitude);
  //     //     print(_distance);
  //     //     if (_distance > 2) {
  //     //       //_positionStreamController.add(position);
  //     //       print('Refresh now');
  //     //     }
  //     //   },
  //     // );
  //     // _positionStream.forEach(
  //     //   (position) {
  //     //     _distance = Geolocator.distanceBetween(_startPosition!.latitude,
  //     //         _startPosition!.longitude, position.latitude, position.longitude);
  //     //     print(_distance);
  //     //     if (_distance > 2) {
  //     //       _getParkingList(position: position);
  //     //       print('Refresh now');
  //     //     }
  //     //   },
  //     // );
  //     // _positionStream.listen(
  //     //   (Position position) {
  //     //     _distance = Geolocator.distanceBetween(_startPosition!.latitude,
  //     //         _startPosition!.longitude, position.latitude, position.longitude);
  //     //     print(_distance);
  //     //     if (_distance > 2) {
  //     //       print('Refresh now');
  //     //       //_getParkingList(position: position);
  //     //     }
  //     //   },
  //     // );
  //     // await for (var position in _positionStream) {
  //     //   _distance = Geolocator.distanceBetween(_startPosition!.latitude,
  //     //       _startPosition!.longitude, position.latitude, position.longitude);
  //     //   print(_distance);
  //     //   if (_distance > 1) {
  //     //     _parkingList = await ParkingListApi()
  //     //         .requestParkingList(refreshPosition: position);
  //     //     _parkingListStreamController.add(_parkingList);
  //     //     _startPosition = position;
  //     //     print('Refresh now done');
  //     //   }
  //     // }
  //   }
  // }
}
