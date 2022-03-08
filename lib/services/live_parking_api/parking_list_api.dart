import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:live_parking_guide/features/live_parking/models/parking_list_data.dart';
import 'package:live_parking_guide/services/device_location/device_location.dart';

class ParkingListApi {
  Future<List<ParkingListData>> startParkingList() async {
    final Position? _position = await DeviceLocation().getCurrentPosition();
    late Uri uri;

    if (_position != null) {
      final latitude = _position.latitude;
      final longitude = _position.longitude;

      uri = Uri.https('data.stad.gent', '/api/records/1.0/search/', {
        "dataset": "bezetting-parkeergarages-real-time",
        "rows": "20",
        "start": "0",
        "format": "json",
        "geofilter.distance": [
          "51.040271, 3.724234, 5000"
        ], //TODO: testing only, delete at the end
        //"geofilter.distance": ["$latitude, $longitude, 5000"],
        "timezone": "UTC"
      });

      return apiRequest(uri: uri, locationEnabled: true);
    } else {
      uri = Uri.https('data.stad.gent', '/api/records/1.0/search/', {
        "dataset": "bezetting-parkeergarages-real-time",
        "rows": "20",
        "start": "0",
        "format": "json",
        "timezone": "UTC"
      });

      return apiRequest(uri: uri, locationEnabled: false);
    }
  }

  Future<List<ParkingListData>> requestParkingList(Position position) async {
    final uri = Uri.https('data.stad.gent', '/api/records/1.0/search/', {
      "dataset": "bezetting-parkeergarages-real-time",
      "rows": "20",
      "start": "0",
      "format": "json",
      "geofilter.distance": [
        "51.040271, 3.724234, 5000"
      ], //TODO: testing only, delete at the end
      // "geofilter.distance": [
      //   "${position.latitude}, ${position.longitude}, 5000"
      // ],
      "timezone": "UTC"
    });

    return apiRequest(uri: uri, locationEnabled: true);
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
