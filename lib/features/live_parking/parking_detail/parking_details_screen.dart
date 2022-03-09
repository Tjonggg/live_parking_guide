import 'package:flutter/material.dart';
import 'package:live_parking_guide/features/live_parking/models/parking_list_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingDetailsScreen extends StatelessWidget {
  static const String id = 'Parking_details_screen';

  const ParkingDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailsData =
        ModalRoute.of(context)!.settings.arguments as ParkingListData;
    List<Marker> _markers = [];

    _markers.add(
      Marker(
        markerId: const MarkerId('SomeId'),
        position: LatLng(detailsData.location[0], detailsData.location[1]),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: detailsData.isOpenNow == 1
            ? const Text(
                ' OPEN ',
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.green,
                ),
              )
            : const Text(
                ' CLOSED ',
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.red,
                ),
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: GoogleMap(
                markers: Set<Marker>.of(_markers),
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(detailsData.location[0], detailsData.location[1]),
                  zoom: 15,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name:\n${detailsData.name}\n\n'),
                  Text('Description:\n${detailsData.description}\n\n'),
                  Text(
                      "Address:\n${detailsData.details['roadName'] ??= ''}\n\n"),
                  Text(
                      "Contact:\n${detailsData.details['contactDetailsTelephoneNumber'] ??= ''}\n\n"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
