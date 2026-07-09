import 'package:flutter/material.dart';
import 'app_map_contract.dart';
import 'native_map_widget.dart';

class MapTestPage extends StatefulWidget {
  const MapTestPage({super.key});

  @override
  State<MapTestPage> createState() => _MapTestPageState();
}

class _MapTestPageState extends State<MapTestPage> {
  AppMapController? _mapController;
  final MapLocation _center = const MapLocation(10.762622, 106.660172); // TPHCM

  void _onMarkerTapped(MapMarker marker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.store, color: Colors.brown, size: 30),
                const SizedBox(width: 12),
                Text(
                  marker.title ?? "Thông tin cửa hàng", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Địa chỉ: ${marker.snippet ?? "N/A"}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Dữ liệu gốc: ${marker.data}", style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Đóng"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kiểm tra Bản đồ"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          NativeMapWidget(
            initialLocation: _center,
            initialZoom: 15,
            onMapCreated: (controller) => _mapController = controller,
          ),
          Positioned(
            bottom: 30, 
            left: 20, 
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildActionBtn(
                        label: "Hiện Markers",
                        icon: Icons.location_on,
                        onPressed: () {
                          _mapController?.setMarkers({
                            MapMarker(
                              id: "store_1", 
                              location: _center, 
                              title: "Coffee Bean Quận 1", 
                              snippet: "123 Lê Lợi, TP.HCM",
                              data: {"store_id": "CB001", "status": "open"}, 
                              onTap: _onMarkerTapped,
                            ),
                            MapMarker(
                              id: "store_2", 
                              location: const MapLocation(10.772, 106.670), 
                              title: "Coffee Bean Quận 3", 
                              snippet: "456 Nguyễn Đình Chiểu",
                              data: {"store_id": "CB002", "status": "closed"}, 
                              onTap: _onMarkerTapped,
                            ),
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionBtn(
                        label: "Vẽ đường đi",
                        icon: Icons.directions,
                        onPressed: () {
                          _mapController?.drawDirections(
                            _center, 
                            const MapLocation(10.772, 106.670)
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildActionBtn(
                  label: "Xóa sạch bản đồ",
                  icon: Icons.delete_outline,
                  onPressed: () => _mapController?.clearMarkers(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionBtn({
    required String label, 
    required IconData icon, 
    required VoidCallback onPressed
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.9),
        foregroundColor: Colors.brown,
        elevation: 4,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
