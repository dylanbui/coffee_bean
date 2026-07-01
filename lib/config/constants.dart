import 'package:coffee_bean/shared/ui/app_assets.dart';

/// --- CATEGORY ICONS MAPPING ---
/// Sử dụng serverId để map icon vì đây là dữ liệu master không đổi.
class CategoryIcons {
  static final Map<int, String> _mapping = {
    1: AppAssets.icons.icCatCoffee,   // Coffee
    2: AppAssets.icons.icCatMilkTea,  // Milk Tea
    3: AppAssets.icons.icCatCake,     // Cake
    4: AppAssets.icons.icCatSnack,    // Snack
    5: AppAssets.icons.icCatTea,      // Tea
  };

  static String getIcon(int catId) {
    return _mapping[catId] ?? AppAssets.icons.icNoImage;
  }
}