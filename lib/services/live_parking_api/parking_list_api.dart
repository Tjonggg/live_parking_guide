import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:live_parking_guide/features/live_parking/models/parking_list_data.dart';
import 'package:live_parking_guide/services/device_location/device_location.dart';

class ParkingListApi {
  Future<List<ParkingListData>> requestParkingList(
      {Position? refreshPosition}) async {
    final Position? _position = await DeviceLocation().getCurrentPosition();
    late Uri _uri;
    double? _latitude;
    double? _longitude;

    if (refreshPosition != null) {
      _latitude = refreshPosition.latitude;
      _longitude = refreshPosition.longitude;
    } else if (_position != null) {
      _latitude = _position.latitude;
      _longitude = _position.longitude;
    }

    if (_latitude != null && _longitude != null) {
      _uri = Uri.https('data.stad.gent', '/api/records/1.0/search/', {
        "dataset": "bezetting-parkeergarages-real-time",
        "rows": "20",
        "start": "0",
        "format": "json",
        "geofilter.distance": [
          "51.040271, 3.724234, 5000"
        ], //TODO: testing only, delete at the end
        //"geofilter.distance": ["$_latitude, $_longitude, 5000"],
        "timezone": "UTC"
      });

      return await apiRequest(uri: _uri, locationEnabled: true);
    } else {
      _uri = Uri.https('data.stad.gent', '/api/records/1.0/search/', {
        "dataset": "bezetting-parkeergarages-real-time",
        "rows": "20",
        "start": "0",
        "format": "json",
        "timezone": "UTC"
      });

      return await apiRequest(uri: _uri, locationEnabled: false);
    }
  }

  Future<List<ParkingListData>> apiRequest(
      {required Uri uri, required bool locationEnabled}) async {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List _temp = [];

      for (var i in data['records']) {
        _temp.add(i['fields']);
      }

      if (!locationEnabled) {
        _temp.sort((a, b) =>
            a['name'].toLowerCase().compareTo(b['name'].toLowerCase()));
      }

      return ParkingListData.parkingFromSnapshot(_temp);
    } else {
      throw Exception('Server response not ok');
    }
  }
}
