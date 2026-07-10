import 'package:db_core/data/db_location.dart';
import 'package:equatable/equatable.dart';

/// 1. Marker toàn năng (Chứa dữ liệu tùy biến thông qua dynamic data)
class MapMarker extends Equatable {
  final String id;
  final DbLocation location;
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

/// 2. Interface điều khiển Map
abstract class AppMapController {
  /// Di chuyển Camera
  Future<void> moveCamera(DbLocation location, {double zoom = 15});
  
  /// Vẽ đường chỉ dẫn giữa 2 điểm
  Future<void> drawDirections(DbLocation start, DbLocation end);
  
  /// Hiển thị InfoWindow của một marker cụ thể
  Future<void> showMarkerInfoWindow(String markerId);
  
  /// Cập nhật danh sách Marker lên bản đồ
  void setMarkers(Set<MapMarker> markers);
  
  /// Xóa sạch Marker
  void clearMarkers();

  void dispose();
}

typedef AppMapCreatedCallback = void Function(AppMapController controller);
