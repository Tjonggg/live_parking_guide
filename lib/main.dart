import 'package:flutter/material.dart';
import 'package:live_parking_guide/features/live_parking/parking_list/widgets/parking_list_screen.dart';

void main() {
  runApp(MyApp()); //TODO: add theme
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Live Parking Guide',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ParkingList(),
    );
  }
}
