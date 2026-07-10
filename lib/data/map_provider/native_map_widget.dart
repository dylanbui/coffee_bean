import 'package:db_core/data/db_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // <--- Điểm cần thay đổi nếu đổi SDK (ví dụ: amap_flutter_map)
import 'package:coffee_bean/data/map_provider/app_map_contract.dart';

/// LỚP HIỂN THỊ BẢN ĐỒ (IMPLEMENTATION LAYER)
/// 
/// Lớp này thực thi (implement) Interface [AppMapController].
/// Mọi thay đổi về SDK bản đồ (Google, AMap, Mapbox) sẽ chỉ diễn ra TRONG file này.
/// Tên class [NativeMapWidget] phải được giữ nguyên để các module UI không bị ảnh hưởng khi đổi SDK.
class NativeMapWidget extends StatefulWidget {
  final DbLocation initialLocation;
  final double initialZoom;
  final Set<MapMarker> markers;
  final AppMapCreatedCallback? onMapCreated;
  final bool myLocationEnabled;

  const NativeMapWidget({
    super.key,
    required this.initialLocation,
    this.initialZoom = 15,
    this.markers = const {},
    this.onMapCreated,
    this.myLocationEnabled = true,
  });

  @override
  State<NativeMapWidget> createState() => _NativeMapWidgetState();
}

/// State quản lý logic hiển thị cụ thể của Google Maps
class _NativeMapWidgetState extends State<NativeMapWidget> implements AppMapController {
  GoogleMapController? _controller;
  Set<Marker> _googleMarkers = {}; // Danh sách marker của riêng Google SDK
  Set<Polyline> _polylines = {};   // Danh sách đường vẽ của riêng Google SDK

  @override
  void initState() {
    super.initState();
    // Chuyển đổi markers từ định dạng chung của dự án sang định dạng của Google SDK
    _googleMarkers = _convertMarkers(widget.markers);
  }

  @override
  void didUpdateWidget(covariant NativeMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Tự động cập nhật markers khi widget bị build lại với dữ liệu mới
    if (widget.markers != oldWidget.markers) {
      _googleMarkers = _convertMarkers(widget.markers);
    }
  }

  /// HÀM CHUYỂN ĐỔI (ADAPTER)
  /// Chuyển từ [MapMarker] (chung của dự án) -> [Marker] (của Google SDK)
  Set<Marker> _convertMarkers(Set<MapMarker> internalMarkers) {
    return internalMarkers.map((m) {
      return Marker(
        markerId: MarkerId(m.id),
        position: LatLng(m.location.latitude, m.location.longitude),
        infoWindow: InfoWindow(
          title: m.title,
          snippet: m.snippet ?? m.address,
        ),
        // Khi tap vào marker của Google, gọi ngược lại callback của MapMarker chung
        onTap: () => m.onTap?.call(m),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    // Widget thực tế của Google Maps SDK
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude),
        zoom: widget.initialZoom,
      ),
      markers: _googleMarkers,
      polylines: _polylines,
      myLocationEnabled: widget.myLocationEnabled,
      onMapCreated: (controller) {
        _controller = controller;
        // Trả chính "this" (đối tượng thực thi AppMapController) về cho Interactor sử dụng
        widget.onMapCreated?.call(this);
      },
    );
  }

  // --- CÁC HÀM THỰC THI INTERFACE AppMapController ---
  // Các hàm này mapping logic từ Interface chung sang các hàm của Google Maps SDK

  @override
  Future<void> moveCamera(DbLocation location, {double zoom = 15}) async {
    await _controller?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(location.latitude, location.longitude),
      zoom,
    ));
  }

  @override
  Future<void> drawDirections(DbLocation start, DbLocation end) async {
    // Để demo, chúng ta vẽ một đường thẳng giữa 2 điểm. 
    // Thực tế bạn sẽ gọi Directions API để lấy danh sách polyline points.
    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId("route_test"),
          points: [
            LatLng(start.latitude, start.longitude),
            LatLng(end.latitude, end.longitude)
          ],
          color: Colors.blue,
          width: 5,
        )
      };
    });
    
    // Auto zoom để thấy cả 2 điểm (Tính toán bounds bao phủ cả Start và End)
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        start.latitude < end.latitude ? start.latitude : end.latitude, 
        start.longitude < end.longitude ? start.longitude : end.longitude
      ),
      northeast: LatLng(
        start.latitude > end.latitude ? start.latitude : end.latitude, 
        start.longitude > end.longitude ? start.longitude : end.longitude
      ),
    );
    await _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Future<void> showMarkerInfoWindow(String markerId) async {
    await _controller?.showMarkerInfoWindow(MarkerId(markerId));
  }

  @override
  void setMarkers(Set<MapMarker> markers) {
    setState(() {
      _googleMarkers = _convertMarkers(markers);
    });
  }

  @override
  void clearMarkers() {
    setState(() {
      _googleMarkers = {};
      _polylines = {};
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
