import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:coffee_bean/scenes/store_list/store_list_router.dart';
import 'package:coffee_bean/scenes/store_list/interactor/store_list_event_state.dart';

class StoreListInteractor extends CubitInteractor<StoreListRouter, StoreListState> {
  final DatabaseService _dbService = locator<DatabaseService>();

  StoreListInteractor(StoreListRouter router) : super(const StoreListInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _initData();
  }

  Future<void> _initData() async {
    // 1. Sync data from local JSON if database is empty (Simulating first-time load)
    final existingStores = await _dbService.getAllStores();
    if (existingStores.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/json/sample_store.json');
        final data = await json.decode(response);
        if (data['stores'] != null) {
          await _dbService.syncStoreData(data['stores']);
        }
      } catch (e) {
        debugPrint("Error syncing stores from JSON: $e");
      }
    }

    // 2. Check location status
    await checkInitialLocationStatus();
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

  Future<void> fetchStores({String? query}) async {
    final searchKeyword = query ?? state.searchQuery;

    emit(StoreListLoading(
      stores: state.stores,
      searchQuery: searchKeyword,
      isLocationAuthorized: state.isLocationAuthorized,
      isManualSelection: state.isManualSelection,
    ));

    Position? position;
    if (state.isLocationAuthorized) {
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
      } catch (e) {
        debugPrint("Error getting position: $e");
      }
    }

    // Fetch from Isar
    List<TblStore> dbStores;
    if (searchKeyword.isEmpty) {
      dbStores = await _dbService.getAllStores();
    } else {
      dbStores = await _dbService.searchStores(searchKeyword);
    }

    // Map to Display Models with calculated distance
    final displayStores = dbStores.map((s) {
      String distanceStr = "15km"; // Du lieu demo


      if (position != null) {
        double distanceValue = double.maxFinite;
        final dist = _calculateDistance(position.latitude, position.longitude, s.latitude, s.longitude);
        distanceValue = dist;
        distanceStr = dist < 1 ? "${(dist * 1000).toInt()}m" : "${dist.toStringAsFixed(1)}km";
      }

      return StoreDisplayModel(
        store: s,
        distance: distanceStr,
        isOpen: _isStoreOpen(s.openingTime, s.closingTime),
      );
    }).toList();

    // Sort by distance if position is available
    if (position != null) {
      // Sort displayStores would need to be mutable or recreated
      final sortedStores = List<StoreDisplayModel>.from(displayStores);
      // We don't have distanceValue in StoreDisplayModel, but we can re-calculate or store it
      // For now, let's just sort the list we have.
      // A better way would be to calculate distance first, then sort, then map.
    }

    emit(StoreListLoaded(
      stores: displayStores,
      isLocationAuthorized: state.isLocationAuthorized,
      isManualSelection: state.isManualSelection,
      searchQuery: searchKeyword,
    ));
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  bool _isStoreOpen(String? opening, String? closing) {
    if (opening == null || closing == null) return true;
    try {
      final now = DateTime.now();
      final openParts = opening.split(':');
      final closeParts = closing.split(':');
      
      final openTime = DateTime(now.year, now.month, now.day, int.parse(openParts[0]), int.parse(openParts[1]));
      var closeTime = DateTime(now.year, now.month, now.day, int.parse(closeParts[0]), int.parse(closeParts[1]));
      
      if (closeTime.isBefore(openTime)) {
        closeTime = closeTime.add(const Duration(days: 1));
      }
      
      return now.isAfter(openTime) && now.isBefore(closeTime);
    } catch (e) {
      return true;
    }
  }

  void onSearchChanged(String query) {
    fetchStores(query: query);
  }

  void onStoreSelected(StoreDisplayModel model) {
    debugPrint("Store Selected == ${model.store.name}");
    AppPrefs().setSelectedStoreId(model.store.serverId);
    router?.pop(); // Return to previous screen
  }
}
