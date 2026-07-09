import 'package:coffee_bean/data/map_provider/app_map_contract.dart';
import 'package:coffee_bean/features/app_map/app_map_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/features/app_map/interactor/app_map_event_state.dart';

class AppMapInteractor extends CubitInteractor<AppMapRouter, AppMapState> {
  AppMapController? mapController;

  AppMapInteractor(MapMarker marker, AppMapRouter router)
      : super(AppMapState(marker: marker), router: router);

  void onMapCreated(AppMapController controller) {
    mapController = controller;
    // Tự động di chuyển Camera đến vị trí marker khi bản đồ sẵn sàng
    mapController?.moveCamera(state.marker.location, zoom: 16);
    // Tự động hiển thị InfoWindow
    mapController?.showMarkerInfoWindow(state.marker.id);
  }
}
