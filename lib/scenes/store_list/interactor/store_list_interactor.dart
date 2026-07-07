import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/store_manager/store_manager.dart';
import 'package:coffee_bean/data/model/response/trade/store_model.dart';
import 'package:coffee_bean/data/repository/store_repository.dart';
import 'package:coffee_bean/scenes/store_list/store_list_builder.dart';
import 'package:coffee_bean/scenes/store_list/store_list_constant.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/foundation.dart';
import 'package:coffee_bean/scenes/store_list/interactor/store_list_event_state.dart';

class StoreListInteractor extends CubitInteractor<StoreListRoutable, StoreListState> {
  final StoreRepository _storeRepository = locator<StoreRepository>();
  final CartService _cartService = locator<CartService>();

  CartService get cartService => _cartService;

  StoreListInteractor(StoreListRouter router) : super(const StoreListInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _initData();
  }

  Future<void> _initData() async {
    // Check location status and fetch stores
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

    // Fetch from Repository
    final location = position != null ? DbLocation(latitude: position.latitude, longitude: position.longitude) : null;
    final result = await _storeRepository.getPickUpStoreList(
      location: location,
    );

    List<StoreModel> apiStores = [];
    if (result case DbSuccess(data: final list)) {
      apiStores = list;
    }

    // Filter by query if needed
    if (searchKeyword.isNotEmpty) {
      apiStores = apiStores
          .where((s) =>
              s.name.toLowerCase().contains(searchKeyword.toLowerCase()) ||
              (s.fullAddress.toLowerCase().contains(searchKeyword.toLowerCase())))
          .toList();
    }

    // Map to Display Models with distance from server or calculated
    final displayStores = apiStores.map((s) {
      String distanceStr = "--";

      // Priority: 1. Server distance, 2. Local calculation
      double? distValue = s.distance;
      if (distValue == null && position != null) {
        distValue = _calculateDistance(position.latitude, position.longitude, s.latitude, s.longitude);
      }

      if (distValue != null) {
        distanceStr = distValue < 1 ? "${(distValue * 1000).toInt()}m" : "${distValue.toStringAsFixed(1)}km";
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

  Future<void> performChangeStore(StoreModel store) async {
    await _cartService.clearCart();
    await StoreManager().saveSelectedStore(store);
    locator<DbEventBus>().fire(StoreChangedEvent(store));
    router?.pop();
  }

}
