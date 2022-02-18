import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:live_parking_guide/features/live_parking/parking_list/models/parking_list_data.dart';

class ParkingListApi {
  static Future<List<ParkingListData>> getParkingList() async {
    var uri = Uri.https('https://data.stad.gent', '/api/records/1.0/search/', {
      "dataset": "bezetting-parkeergarages-real-time",
      "rows": 10,
      "start": 0,
      "sort": ["-occupation"],
      "facet": ["name", "lastupdate", "description", "categorie"],
      "format": "json",
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
