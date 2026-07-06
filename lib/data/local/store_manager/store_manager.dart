import 'dart:convert';
import 'package:coffee_bean/data/model/response/trade/store_model.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/foundation.dart';

class StoreManager extends ChangeNotifier {
  // 1. Singleton Pattern
  StoreManager._internal();
  static final StoreManager _instance = StoreManager._internal();
  factory StoreManager() => _instance;

  static const String _storeKey = "SELECTED_STORE";

  StoreModel? _selectedStore;
  StoreModel? get selectedStore => _selectedStore;

  /// Gọi duy nhất 1 lần lúc khởi chạy App (trong hàm main.dart hoặc app.dart)
  Future<void> init() async {
    final dynamic data = DbSharedPreferences().get(_storeKey);
    if (data != null && data is String) {
      try {
        _selectedStore = StoreModel.fromJson(jsonDecode(data));
      } catch (_) {
        _selectedStore = null;
      }
    }
    notifyListeners();
  }

  /// Lưu thông tin cửa hàng đã chọn (Guest hoặc User đều dùng được)
  Future<void> saveSelectedStore(StoreModel store) async {
    // Chỉ thực hiện logic xóa cache nếu store thực sự thay đổi hoặc chưa có store nào
    if (_selectedStore != null && _selectedStore?.id == store.id) {
      return;
    }

    _selectedStore = store;
    await DbSharedPreferences().set(_storeKey, jsonEncode(store.toJson()));
    
    // Xóa cache khi đổi cửa hàng để đảm bảo menu và giá cả chính xác
    if (locator.isRegistered<DbCacheProvider>()) {
      // Xóa sạch để đảm bảo an toàn tuyệt đối khi đổi chi nhánh
      await locator<DbCacheProvider>().clearAll();
    }

    notifyListeners();
  }

  /// Xóa cửa hàng đã chọn (nếu cần)
  Future<void> clearStore() async {
    _selectedStore = null;
    await DbSharedPreferences().remove(_storeKey);
    notifyListeners();
  }
}
