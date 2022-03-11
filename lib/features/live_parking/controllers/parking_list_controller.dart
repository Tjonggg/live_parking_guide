import 'dart:async';

import 'package:live_parking_guide/features/live_parking/models/parking_list_data.dart';
import 'package:live_parking_guide/services/device_location_provider/device_location_provider.dart';
import 'package:live_parking_guide/services/live_parking_api/parking_list_api.dart';

class ParkingListController {
  List<ParkingListData> _parkingList = [];
  List<ParkingListData>? get parkingList => _parkingList;

  final StreamController<List<ParkingListData>>
      _getParkingListStreamController =
      StreamController<List<ParkingListData>>();
  Stream<List<ParkingListData>> get getParkingListStream =>
      _getParkingListStreamController.stream;

  final DeviceLocationProvider _deviceLocationProvider =
      DeviceLocationProvider();

  Future<void> initParkingList() async {
    _parkingList = await ParkingListApi().requestParkingList();
    _getParkingListStreamController.add(_parkingList);
    _refreshParkingList();
  }

  void _refreshParkingList() {
    _deviceLocationProvider.initDeviceLocationProvider();
    _deviceLocationProvider.refreshPositionStream.listen((position) async {
      _parkingList =
          await ParkingListApi().requestParkingList(refreshPosition: position);
      _getParkingListStreamController.add(_parkingList);
    });

    //TODO: add timer refresh
  }
}
