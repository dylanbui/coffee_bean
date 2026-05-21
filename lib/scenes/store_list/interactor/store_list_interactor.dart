import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:coffee_bean/scenes/store_list/store_list_router.dart';
import 'package:coffee_bean/scenes/store_list/interactor/store_list_event_state.dart';

class StoreListInteractor extends CubitInteractor<StoreListRouter, StoreListState> {
  StoreListInteractor(StoreListRouter router) : super(const StoreListInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    checkInitialLocationStatus();
  }

  Future<void> checkInitialLocationStatus() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      emit(StoreListLoaded(
        stores: state.stores,
        isLocationAuthorized: true,
        isManualSelection: false,
      ));
      fetchStores();
    } else {
      emit(StoreListLoaded(
        stores: state.stores,
        isLocationAuthorized: false,
        isManualSelection: false,
      ));
    }
  }

  Future<void> requestLocationPermission() async {
    emit(StoreListLoading(
      stores: state.stores,
      isLocating: true,
      isManualSelection: false,
      isLocationAuthorized: state.isLocationAuthorized,
    ));

    final status = await Permission.location.request();
    
    if (status.isGranted) {
      emit(StoreListLoaded(
        stores: state.stores,
        isLocationAuthorized: true,
        isManualSelection: false,
        isLocating: false,
      ));
      fetchStores();
    } else {
      emit(StoreListLoaded(
        stores: state.stores,
        isLocationAuthorized: false,
        isManualSelection: false,
        isLocating: false,
      ));
    }
  }

  void enableManualSelection() {
    emit(StoreListLoaded(
      stores: state.stores,
      isLocationAuthorized: state.isLocationAuthorized,
      isManualSelection: true,
    ));
    fetchStores();
  }

  Future<void> fetchStores() async {
    emit(StoreListLoading(
      stores: state.stores,
      searchQuery: state.searchQuery,
      isLocationAuthorized: state.isLocationAuthorized,
      isManualSelection: state.isManualSelection,
    ));

    Position? position;
    if (state.isLocationAuthorized) {
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        debugPrint("Current Position: ${position.latitude}, ${position.longitude}");
      } catch (e) {
        debugPrint("Error getting position: $e");
      }
    }

    // Simulate API call with coordinates if available
    await Future.delayed(const Duration(seconds: 1));

    final mockStores = [
      Store(
        id: '1',
        name: position != null ? 'Nearby Store ABC' : 'Store Name ABC',
        address: 'No. XX, XX Road, XX Town, Jing\'an District, Shanghai',
        hours: '09:00-23:00',
        distance: position != null ? '200m' : '198m',
        isOpen: true,
      ),
      Store(
        id: '2',
        name: 'Long Store Name ABC Placeholder',
        address: 'Very long address example in Jing\'an District, Shanghai, showing how it wraps to multiple lines',
        hours: '09:00-21:30',
        distance: '1.2km',
        isOpen: false,
      ),
    ];

    emit(StoreListLoaded(
      stores: mockStores,
      isLocationAuthorized: state.isLocationAuthorized,
      isManualSelection: state.isManualSelection,
      searchQuery: state.searchQuery,
    ));
  }

  void onSearchChanged(String query) {
    debugPrint("Query == $query");
    emit(StoreListLoaded(
      stores: state.stores,
      searchQuery: query,
      isLocationAuthorized: state.isLocationAuthorized,
      isManualSelection: state.isManualSelection,
    ));
  }

  void onStoreSelected(Store store) {
    debugPrint("Store Name == ${store.name}");
  }
}
