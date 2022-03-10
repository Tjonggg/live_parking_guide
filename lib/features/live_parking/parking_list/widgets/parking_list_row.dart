import 'package:flutter/material.dart';
import 'package:live_parking_guide/features/live_parking/models/parking_list_data.dart';
import 'package:live_parking_guide/features/live_parking/parking_detail/parking_details_screen.dart';

class ParkingListRow extends StatelessWidget {
  final String name;
  final String status;
  final bool available;
  final ParkingListData details;

  // ignore: use_key_in_widget_constructors
  const ParkingListRow({
    required this.name,
    required this.status,
    required this.available,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      child: ListTile(
        leading: Text(
          status,
          style: TextStyle(
            color: available ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          name,
          textAlign: TextAlign.right,
        ),
        onTap: () {
          //TODO: stop timer en locatie listener (override dispose)
          Navigator.pushNamed(context, ParkingDetailsScreen.id,
              arguments: details);
        },
      ),
    );
  }
}
