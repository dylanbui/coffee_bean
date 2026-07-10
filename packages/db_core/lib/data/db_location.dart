import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class DbLocation extends Equatable {
  final double latitude;
  final double longitude;

  const DbLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];

  @override
  String toString() => 'Lat: $latitude, Lng: $longitude';

  // Nếu cần convert sang Map (ví dụ lưu SharedPreferences hoặc gửi API)
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Nếu cần tạo lại từ Map
  factory DbLocation.fromMap(Map<String, dynamic> map) {
    return DbLocation(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }
}

extension PositionExtension on Position {
  DbLocation toDbLocation() {
    return DbLocation(latitude: latitude, longitude: longitude);
  }
}
