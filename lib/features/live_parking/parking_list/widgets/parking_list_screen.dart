import 'package:flutter/material.dart';
import 'package:live_parking_guide/features/live_parking/parking_list/models/parking_list_data.dart';
import 'package:live_parking_guide/features/live_parking/parking_list/widgets/parking_list_row.dart';
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
  late List<ParkingListData> _parkingList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    loadParkingList();
  }

  Future<void> loadParkingList() async {
    _parkingList = await ParkingListApi.getParkingList();
    setState(() {
      _isLoading = false; //TODO: loading check
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
                    _parkingList[index]
                        .totalCapacity, //TODO: kleur heeft nog geen state
              );
            },
          );
  }
}
