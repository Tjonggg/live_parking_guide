import 'package:flutter/material.dart';
import 'package:live_parking_guide/features/live_parking/controllers/parking_list_controller.dart';
import 'package:live_parking_guide/features/live_parking/models/parking_list_data.dart';
import 'package:live_parking_guide/features/live_parking/parking_list/widgets/parking_list_row.dart';
import 'package:live_parking_guide/main.dart';
import 'package:live_parking_guide/services/device_location_provider/device_location_provider.dart';

class ParkingListScreen extends StatefulWidget {
  static const String id = 'Parking_list_screen';

  const ParkingListScreen({Key? key}) : super(key: key);

  @override
  State<ParkingListScreen> createState() => _ParkingListScreenState();
}

class _ParkingListScreenState extends State<ParkingListScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    DeviceLocationProvider.positionStream!.cancel();
    ParkingListController.refreshTimer!.cancel();
  }

  @override
  void didPopNext() {
    ParkingListController().startTimer();
    DeviceLocationProvider().startLocationListener(
        refreshPostion: DeviceLocationProvider.refreshPosition!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_parking),
            SizedBox(
              width: 10,
            ),
            Text('Live Parking Gent'),
          ],
        ),
      ),
      body: const _ListBuilder(),
    );
  }
}

class _ListBuilder extends StatelessWidget {
  const _ListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ParkingListController _parkingListController =
        ParkingListController();

    _parkingListController.initParkingList();

    return StreamBuilder(
      stream: _parkingListController.getParkingListStream,
      builder: (context, AsyncSnapshot<List<ParkingListData>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ParkingListRow(
                name: snapshot.data![index].name,
                status:
                    '${snapshot.data![index].occupation}/${snapshot.data![index].totalCapacity}',
                available: snapshot.data![index].occupation !=
                    snapshot.data![index].totalCapacity,
                details: snapshot.data![index],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
