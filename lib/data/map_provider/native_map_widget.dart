import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'app_map_contract.dart';

class NativeMapWidget extends StatefulWidget {
  final MapLocation initialLocation;
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

class _NativeMapWidgetState extends State<NativeMapWidget> implements AppMapController {
  GoogleMapController? _controller;
  Set<Marker> _googleMarkers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _googleMarkers = _convertMarkers(widget.markers);
  }

  @override
  void didUpdateWidget(covariant NativeMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.markers != oldWidget.markers) {
      _googleMarkers = _convertMarkers(widget.markers);
    }
  }

  Set<Marker> _convertMarkers(Set<MapMarker> internalMarkers) {
    return internalMarkers.map((m) {
      return Marker(
        markerId: MarkerId(m.id),
        position: LatLng(m.location.latitude, m.location.longitude),
        infoWindow: InfoWindow(
          title: m.title,
          snippet: m.snippet ?? m.address,
        ),
        onTap: () => m.onTap?.call(m),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
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
        widget.onMapCreated?.call(this);
      },
    );
  }

  @override
  Future<void> moveCamera(MapLocation location, {double zoom = 15}) async {
    await _controller?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(location.latitude, location.longitude),
      zoom,
    ));
  }

  @override
  Future<void> drawDirections(MapLocation start, MapLocation end) async {
    // Để demo, chúng ta vẽ một đường thẳng giữa 2 điểm. 
    // Thực tế bạn sẽ gọi Directions API để lấy polyline points.
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
    
    // Auto zoom để thấy cả 2 điểm
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
