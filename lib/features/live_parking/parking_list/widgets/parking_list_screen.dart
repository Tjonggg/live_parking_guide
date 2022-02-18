import 'package:flutter/material.dart';
import 'package:live_parking_guide/features/live_parking/parking_list/widgets/parking_list_row.dart';

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
      body: _listBuilder(),
    );
  }
}

class _listBuilder extends StatefulWidget {
  const _listBuilder({Key? key}) : super(key: key);

  @override
  State<_listBuilder> createState() => _listBuilderState();
}

class _listBuilderState extends State<_listBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 15,
      itemBuilder: (context, index) {
        if (index < 10) {
          return ParkingListRow(
              name: 'een parking naam', status: '50/200', available: true);
        }
        return Text('Einde lijst');
      },
    );
  }
}
