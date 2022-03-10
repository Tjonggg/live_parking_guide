import 'package:flutter/material.dart';
import 'package:live_parking_guide/features/live_parking/parking_detail/parking_details_screen.dart';
import 'package:live_parking_guide/features/live_parking/parking_list/parking_list_screen.dart';

//TODO: NICE TO HAVE: hide apikey(+android key), add theme(tablet support), UT's
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Live Parking Guide',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ParkingListScreen(),
      routes: {
        ParkingListScreen.id: (context) => const ParkingListScreen(),
        ParkingDetailsScreen.id: (context) => const ParkingDetailsScreen(),
      },
      initialRoute: ParkingListScreen.id,
    );
  }
}
