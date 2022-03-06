import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceLocation {
  //TODO: stream voor locatie bepaling of plaatsen beschikbaar? provider en changenotifier/listener
  Future<Position?> getCurrentPosition() async {
    Position? _position = null;
    //final permissionStatus = await Permission.location.status;
    final permissionStatus = PermissionStatus.denied;

    if (!permissionStatus.isGranted) {
      await Permission.locationWhenInUse.request();
    }

    // TO DO: Error handling!!! + socket exception
    if (permissionStatus.isGranted || permissionStatus.isLimited) {
      _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    return _position;
  }
}
