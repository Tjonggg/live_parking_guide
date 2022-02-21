import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:live_parking_guide/features/live_parking/parking_list/models/parking_list_data.dart';

class ParkingListApi {
  static Future<List<ParkingListData>> getParkingList() async {
    var uri = Uri.https('data.stad.gent', '/api/records/1.0/search/', {
      "dataset": "bezetting-parkeergarages-real-time",
      "rows": "20",
      "start": "0",
      "format": "json",
      "geofilter.distance": ["51.040271, 3.724234, 5000"],
      "timezone": "UTC"
    });

    final response = await http.get(uri);

    Map data = jsonDecode(response.body);

    List _temp = [];

    for (var i in data['records']) {
      _temp.add(i['fields']);
    }

    return ParkingListData.parkingFromSnapshot(_temp);
  }
}
