class ParkingListData {
  final int occupation;
  final bool isOpenNow;
  final String description;
  final String name;
  final int totalCapacity;
  final List<int> location;

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
      isOpenNow: json['isOpenNow'] as bool,
      description: json['description'] as String,
      name: json['name'] as String,
      totalCapacity: json['totalCapacity'] as int,
      location: json['location'] as List<int>,
    );
  }

  static List<ParkingListData> parkingFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ParkingListData.fromJson(data);
    }).toList();
  }
}
