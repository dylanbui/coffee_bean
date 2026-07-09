import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// 1. Định nghĩa Tọa độ
class MapLocation extends Equatable {
  final double latitude;
  final double longitude;
  const MapLocation(this.latitude, this.longitude);
  @override
  List<Object?> get props => [latitude, longitude];
}

/// 2. Marker toàn năng (Chứa dữ liệu tùy biến thông qua dynamic data)
class MapMarker extends Equatable {
  final String id;
  final MapLocation location;
  final String? title;
  final String? snippet;
  final String? address;
  final String? iconAsset;
  final dynamic data; // Chứa bất kỳ Object nào (Store, User, Event...)
  final void Function(MapMarker marker)? onTap;

  const MapMarker({
    required this.id,
    required this.location,
    this.title,
    this.snippet,
    this.address,
    this.iconAsset,
    this.data,
    this.onTap,
  });

  @override
  List<Object?> get props => [id, location, title, snippet, address, iconAsset, data];
}

/// 3. Interface điều khiển Map
abstract class AppMapController {
  /// Di chuyển Camera
  Future<void> moveCamera(MapLocation location, {double zoom = 15});
  
  /// Vẽ đường chỉ dẫn giữa 2 điểm
  Future<void> drawDirections(MapLocation start, MapLocation end);
  
  /// Hiển thị InfoWindow của một marker cụ thể
  Future<void> showMarkerInfoWindow(String markerId);
  
  /// Cập nhật danh sách Marker lên bản đồ
  void setMarkers(Set<MapMarker> markers);
  
  /// Xóa sạch Marker
  void clearMarkers();

  void dispose();
}

typedef AppMapCreatedCallback = void Function(AppMapController controller);
