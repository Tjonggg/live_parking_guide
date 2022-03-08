import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_parking_guide/features/live_parking/models/parking_list_data.dart';
import 'package:live_parking_guide/features/live_parking/parking_list/widgets/parking_list_row.dart';
import 'package:live_parking_guide/services/device_location/device_location.dart';
import 'package:live_parking_guide/services/live_parking_api/parking_list_api.dart';

//TODO: stop timer en locatie listener
//TODO: rood/groen kleur heeft nog geen state
class ParkingListScreen extends StatelessWidget {
  static const String id = 'Parking_list_screen';
  const ParkingListScreen({Key? key}) : super(key: key);

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

class _ListBuilder extends StatefulWidget {
  const _ListBuilder({Key? key}) : super(key: key);

  @override
  State<_ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<_ListBuilder> {
  List<ParkingListData> _parkingList = [];
  bool _isLoading = true;
  Position? startPosition;

  final Stream<Position> _positionStream = Geolocator.getPositionStream();

  @override
  void initState() {
    super.initState();

    startParkingList();
  }

  // void dispose() {
  //   _positionStream
  // }

  Future<void> startParkingList() async {
    _parkingList = await ParkingListApi().startParkingList();
    setState(() {
      _isLoading = false;
    });

    startPosition = await DeviceLocation()
        .getCurrentPosition(); //TODO: dit klopt denk ik niet
    if (startPosition != null) {
      double _distance;
      _positionStream.listen((position) {
        _distance = Geolocator.distanceBetween(startPosition!.latitude,
            startPosition!.longitude, position.latitude, position.longitude);
        if (_distance > 2) {
          setState(() {
            _isLoading = true;
          });
          _requestRefreshStream(position);
        }
      });
    }
  }

  Future<void> _requestRefreshStream(Position position) async {
    _parkingList = await ParkingListApi().requestParkingList(position);
    setState(() {
      _isLoading = false;
    });
    startPosition = position;
    print('Refresh done');
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _parkingList.length,
            itemBuilder: (context, index) {
              return ParkingListRow(
                name: _parkingList[index].name,
                status:
                    '${_parkingList[index].occupation}/${_parkingList[index].totalCapacity}',
                available: _parkingList[index].occupation !=
                    _parkingList[index].totalCapacity,
                details: _parkingList[index],
              );
            },
          );
  }
}