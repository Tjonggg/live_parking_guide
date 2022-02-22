import 'package:flutter/material.dart';

class ParkingListRow extends StatelessWidget {
  final String name;
  final String status;
  final bool available;

  const ParkingListRow({
    required this.name,
    required this.status,
    required this.available,
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
        onTap: () {},
      ),
    );
  }
}