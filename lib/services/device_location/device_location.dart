import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceLocation {
  Future<Position> getCurrentPosition() async {
    var locationStatus = await Permission
        .location.status; //nice to have, zet dit op de juiste plaats

    if (!locationStatus.isGranted) {
      await Permission.locationWhenInUse.request();
    }

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
