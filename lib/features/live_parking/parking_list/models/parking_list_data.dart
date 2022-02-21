class ParkingListData {
  final int occupation;
  final int isOpenNow;
  final String description;
  final String name;
  final int totalCapacity;
  final List<dynamic> location;

  ParkingListData({
    required this.occupation,
    required this.isOpenNow,
    required this.description,
    required this.name,
    required this.totalCapacity,
    required this.location,
  });

  factory ParkingListData.fromJson(dynamic json) {
    return ParkingListData(
      occupation: json['occupation'] as int,
      isOpenNow: json['isopennow'] as int,
      description: json['description'] as String,
      name: json['name'] as String,
      totalCapacity: json['totalcapacity'] as int,
      location: json['location'] as List<dynamic>,
    );
  }

  static List<ParkingListData> parkingFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ParkingListData.fromJson(data);
    }).toList();
  }

  // @override
  // String toString() {
  //   return 'Parking\n{occupation: $occupation, isOpenNow: $isOpenNow, description: $description, name: $name, totalCapacity: $totalCapacity, location: $location\n}';
  // }
}
