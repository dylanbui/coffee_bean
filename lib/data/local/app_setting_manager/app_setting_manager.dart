import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/utils/language_utils.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/cupertino.dart';

/// Sự kiện bắn đi khi có thay đổi cài đặt hệ thống
class AppSettingChangedEvent extends DbBaseEvent {}

class AppSettingManager {
  static final AppSettingManager _instance = AppSettingManager._internal();
  factory AppSettingManager() => _instance;
  AppSettingManager._internal();

  static const String _langKey = "APP_LANGUAGE";
  static const String _currencyKey = "APP_CURRENCY";

  // Các biến static để truy cập nhanh từ Extension/UI mà không cần async
  static Language currentLanguage = Language.vi;
  static Currency currentCurrency = Currency.vnd;

  /// Khởi tạo: Gọi duy nhất 1 lần lúc startup (main.dart)
  Future<void> init() async {
    final langCode = DbSharedPreferences().get(_langKey) as String?;
    final currencyName = DbSharedPreferences().get(_currencyKey) as String?;

    if (langCode != null) {
      currentLanguage = Language.values.firstWhere(
        (e) => e.code == langCode, 
        orElse: () => Language.vi
      );
    }
    
    if (currencyName != null) {
      currentCurrency = Currency.values.firstWhere(
        (e) => e.name == currencyName, 
        orElse: () => Currency.vnd
      );
    }
  }

  /// Cập nhật Settings
  Future<void> updateSettings({Language? lang, Currency? currency}) async {
    bool isChanged = false;

    if (lang != null && lang != currentLanguage) {
      dLog("AppSettingManager: Changing language to ${lang.code}");
      currentLanguage = lang;
      await DbSharedPreferences().set(_langKey, lang.code);
      isChanged = true;
    }

    if (currency != null && currency != currentCurrency) {
      dLog("AppSettingManager: Changing currency to ${currency.name}");
      currentCurrency = currency;
      await DbSharedPreferences().set(_currencyKey, currency.name);
      isChanged = true;
    }

    if (isChanged) {
      dLog("AppSettingManager: Firing AppSettingChangedEvent");
      debugPrint("AppSettingManager: Firing AppSettingChangedEvent");
      // Bắn event qua EventBus để AppInteractor xử lý reboot
      locator<DbEventBus>().fire(AppSettingChangedEvent());
    } else {
      dLog("AppSettingManager: No changes detected, but forcing reload for UI consistency");
      debugPrint("AppSettingManager: No changes detected, but forcing reload for UI consistency");
      locator<DbEventBus>().fire(AppSettingChangedEvent());
    }
  }
}
