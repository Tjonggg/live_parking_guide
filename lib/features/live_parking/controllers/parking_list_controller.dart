import 'package:flutter/material.dart';
import 'package:live_parking_guide/features/live_parking/models/parking_list_data.dart';
import 'package:live_parking_guide/services/device_location_provider/device_location_provider.dart';
import 'package:live_parking_guide/services/live_parking_api/parking_list_api.dart';

class ParkingListController extends ChangeNotifier {
  List<ParkingListData> _parkingList = [];
  List<ParkingListData>? get parkingList => _parkingList;

  final DeviceLocationProvider _deviceLocationProvider =
      DeviceLocationProvider();

  Future<void> initParkingList() async {
    _parkingList = await ParkingListApi().requestParkingList();
    notifyListeners();
    _refreshParkingList();
  }

  void _refreshParkingList() {
    //TODO: add timer refresh
    _deviceLocationProvider.addListener(() async {
      print('We krijgen iets binnen');
      if (_deviceLocationProvider.position != null) {
        _parkingList = await ParkingListApi().requestParkingList(
            refreshPosition: _deviceLocationProvider.position);
        notifyListeners();
      } else {
        _parkingList = await ParkingListApi().requestParkingList();
        notifyListeners();
        print('Start lijst');
      }
    });

    _deviceLocationProvider.initDeviceLocationProvider();
  }

  //await Future<void>.delayed(const Duration(seconds: 3));
  // Future<void> _getParkingList({Position? position}) async {
  //   if (position != null) {
  //     // _positionStreamSubscription.pause();
  //     _startPosition = position;
  //     _parkingList =
  //         await ParkingListApi().requestParkingList(refreshPosition: position);
  //     _parkingListStreamController.add(_parkingList);
  //     print('Refresh done $_startPosition');
  //     //_startListRefresh();
  //   } else {
  //     _parkingList = await ParkingListApi().requestParkingList();
  //     _parkingListStreamController.add(_parkingList);
  //     print('Init list');
  //   }
  // }

  // @override
  // String toString() {
  //   return '\nPrivate: $_private\nPublic: $public';
  // }
}
