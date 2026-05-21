import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  static const _Images images = _Images();
  static const _Icons icons = _Icons();
  static const _Json json = _Json();
}

class _Icons {
  const _Icons();

  final String icMy = 'assets/icons/ic_my.svg';
  final String icHome = 'assets/icons/ic_home.svg';
  final String icShopping = 'assets/icons/ic_shopping.svg';
  final String icMyActive = 'assets/icons/ic_my_active.svg';
  final String icHomeActive = 'assets/icons/ic_home_active.svg';
  final String icCommunication = 'assets/icons/ic_communication.svg';
  final String icEmptyLocation = 'assets/icons/ic_empty_location.svg';
  final String icShoppingActive = 'assets/icons/ic_shopping_active.svg';
  final String icCommunicationActive = 'assets/icons/ic_communication_active.svg';
  final String icDatCho = 'assets/icons/ic_dat_cho.svg';
  final String icDoiDiem = 'assets/icons/ic_doi_diem.svg';
  final String icKhoaHoc = 'assets/icons/ic_khoa_hoc.svg';
  final String icTrungTam = 'assets/icons/ic_trung_tam.svg';
  final String icSearch = 'assets/icons/ic_search.svg';
  final String icComment = 'assets/icons/ic_comment.svg';
  final String icLike = 'assets/icons/ic_like.svg';
  final String icShare = 'assets/icons/ic_share.svg';
  final String icPlayVideo = 'assets/icons/ic_play_video.svg';
  final String icPlusCycle = 'assets/icons/ic_plus_cycle.svg';
  final String icPlusCycleWhite = 'assets/icons/ic_plus_cycle_white.svg';
  final String icCatCake = 'assets/icons/ic_cat_cake.svg';
  final String icCatCoffee = 'assets/icons/ic_cat_coffee.svg';
  final String icCatMilkTea = 'assets/icons/ic_cat_milk_tea.svg';
  final String icCatSnack = 'assets/icons/ic_cat_snack.svg';
  final String icCatTea = 'assets/icons/ic_cat_tea.svg';
  final String icBgKhoangCach = 'assets/icons/ic_bg_khoang_cach.svg';


}

class _Images {
  const _Images();
  final String bgSplash = 'assets/images/bg_splash.png';
  final String filterCheckAllSelected = 'assets/images/filter_check_all_selected.svg';
  final String icArrowLeftWhite = 'assets/images/ic_arrow_left_white.svg';
  final String icCheckWrongRed = 'assets/images/ic_check_wrong_red.svg';
  final String checkboxNormal = 'assets/images/checkbox_normal.svg';
  final String filterCheckAll = 'assets/images/filter_check_all.svg';
  final String icCircleCheckbox = 'assets/images/ic_circle_checkbox.svg';
  final String checkboxSelected = 'assets/images/checkbox_selected.svg';
  final String icArrowDownBlack = 'assets/images/ic_arrow_down_black.svg';
  final String icArrowLeftBlack = 'assets/images/ic_arrow_left_black.svg';
  final String icArrowRightWhite = 'assets/images/ic_arrow_right_white.svg';
  final String icCheckRightGreen = 'assets/images/ic_check_right_green.svg';
  final String logoSplash = 'assets/images/logo_splash.png';
  final String logoTmLabs = 'assets/images/logo_tmlabs.png';
  final String imgBgKhoangCach = 'assets/images/img_bg_khoang_cach.png';
}

class _Json {
  const _Json();
  final String emptySearching = 'assets/json/empty_searching.json';
  final String propzyHomePromoCode = 'assets/json/propzy_home_promo_code.json';
  final String loading = 'assets/json/loading.json';
  final String introduce1 = 'assets/json/introduce1.json';
  final String introduce3 = 'assets/json/introduce3.json';
  final String introduce2 = 'assets/json/introduce2.json';
  final String propzyHomeManBuildHouse = 'assets/json/propzy_home_man_build_house.json';
  final String logoSplashScreen = 'assets/json/logo_splash_screen.json';
  final String lottieAnimationGrowingHouse = 'assets/json/lottie_view_animation_growing_house_propzy_home.json';
}

class AppIcon extends StatelessWidget {
  final dynamic icon;
  final Color? color;
  final double? size;

  const AppIcon(this.icon, {super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    if (icon == null) return const SizedBox.shrink();

    if (icon is IconData) {
      return Icon(icon as IconData, color: color, size: size);
    }

    if (icon is String) {
      final String iconPath = icon as String;
      if (iconPath.endsWith('.svg')) {
        return SvgPicture.asset(
          iconPath,
          width: size,
          height: size,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );
      }
      return Image.asset(iconPath, width: size, height: size, color: color);
    }

    return const SizedBox.shrink();
  }
}