import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:live_parking_guide/features/live_parking/models/parking_list_data.dart';

class ParkingListApi {
  Future<List<ParkingListData>> requestParkingList(
      {Position? refreshPosition}) async {
    late Uri _uri;
    double? _latitude;
    double? _longitude;

    if (refreshPosition != null) {
      _latitude = refreshPosition.latitude;
      _longitude = refreshPosition.longitude;
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

      return await _apiRequest(uri: _uri, locationEnabled: true);
    } else {
      _uri = Uri.https('data.stad.gent', '/api/records/1.0/search/', {
        "dataset": "bezetting-parkeergarages-real-time",
        "rows": "20",
        "start": "0",
        "format": "json",
        "timezone": "UTC"
      });

      return await _apiRequest(uri: _uri, locationEnabled: false);
    }
  }

  Future<List<ParkingListData>> _apiRequest(
      {required Uri uri, required bool locationEnabled}) async {
    final _response = await http.get(uri);

    if (_response.statusCode == 200) {
      Map _data = jsonDecode(_response.body);
      List _temp = [];

      for (var i in _data['records']) {
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
