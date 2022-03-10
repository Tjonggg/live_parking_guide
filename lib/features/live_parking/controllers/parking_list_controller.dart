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
    _refreshParkingList();
    notifyListeners();
  }

  void _refreshParkingList() {
    //TODO: add timer refresh
    _deviceLocationProvider.addListener(() async {
      if (_deviceLocationProvider.position != null) {
        _parkingList = await ParkingListApi().requestParkingList(
            refreshPosition: _deviceLocationProvider.position);
        notifyListeners();
      }
    });

    _deviceLocationProvider.initDeviceLocationProvider();
  }
}
