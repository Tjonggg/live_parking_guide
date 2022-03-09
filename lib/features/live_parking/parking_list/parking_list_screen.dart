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
  Position? _startPosition;

  final Stream<Position> _positionStream = Geolocator.getPositionStream();

  @override
  void initState() {
    super.initState();

    _startParkingList();
  }

  Future<void> _startParkingList() async {
    await _getParkingList();

    _startPosition =
        await DeviceLocation().getCurrentPosition(); //TODO: dit kan beter
    if (_startPosition != null) {
      double _distance;
      _positionStream.listen((position) {
        _distance = Geolocator.distanceBetween(_startPosition!.latitude,
            _startPosition!.longitude, position.latitude, position.longitude);
        print(_distance);
        if (_distance > 2) {
          _getParkingList(position: position);
        }
      });
    }
  }

  Future<void> _getParkingList({Position? position}) async {
    setState(() {
      _isLoading = true;
    });
    if (position != null) {
      _parkingList =
          await ParkingListApi().requestParkingList(refreshPosition: position);
      _startPosition = position;
      print('Refresh done');
    } else {
      _parkingList = await ParkingListApi().requestParkingList();
      print('Normal request');
    }
    setState(() {
      _isLoading = false;
    });
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
