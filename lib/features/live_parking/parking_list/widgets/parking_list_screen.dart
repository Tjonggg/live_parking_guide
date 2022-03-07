import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_parking_guide/features/live_parking/parking_list/models/parking_list_data.dart';
import 'package:live_parking_guide/features/live_parking/parking_list/widgets/parking_list_row.dart';
import 'package:live_parking_guide/services/device_location/device_location.dart';
import 'package:live_parking_guide/services/live_parking_api/parking_list_api.dart';

class ParkingList extends StatelessWidget {
  const ParkingList({Key? key}) : super(key: key);

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
  //StreamController _refreshListStream = StreamController();

  @override
  void initState() {
    super.initState();

    startParkingList();
  }

  Future<void> startParkingList() async {
    _parkingList = await ParkingListApi.startParkingList();
    setState(() {
      _isLoading = false;
    });

    startPosition = await DeviceLocation()
        .getCurrentPosition(); //TODO: dit klopt denk ik niet
    if (startPosition != null) {
      double _distance;
      _positionStream.listen((position) {
        //TODO: when to stop listening
        _distance = Geolocator.distanceBetween(startPosition!.latitude,
            startPosition!.longitude, position.latitude, position.longitude);
        print('$_distance');
        if (_distance > 10) {
          setState(() {
            _isLoading = true;
          });
          _requestRefreshStream(position);
        }
      });
    }
  }

  Future<void> _requestRefreshStream(Position position) async {
    _parkingList = await ParkingListApi.requestParkingList(position);
    setState(() {
      _isLoading = false;
    });
    startPosition = position;
  }

  //TODO: refactor deze 2 voids
  // void scheduledRefreshParkingList() {
  //   Timer scheduleRefresh(int sec) =>
  //       Timer(Duration(seconds: 5), scheduledRefreshParkingList);
  //   setState(() async {
  //     _isLoading = true;
  //     _parkingList = await ParkingListApi.startParkingList();
  //     _isLoading = false;
  //     print('schedule refresh done');
  //   });
  // }
  // Future<void> requestParkingList() async {
  //   _parkingList = await ParkingListApi.startParkingList();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  // Stream<List<ParkingListData>> _parkingListStream(Position position) async* {
  //   _parkingList = await ParkingListApi.requestParkingList(position);
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   yield _parkingList;
  // }

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
                    _parkingList[index]
                        .totalCapacity, //TODO: kleur heeft nog geen state
              );
            },
          );
  }
}
