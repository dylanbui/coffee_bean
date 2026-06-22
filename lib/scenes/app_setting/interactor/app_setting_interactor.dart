import 'dart:async';
import 'package:coffee_bean/data/local/app_setting_manager/app_setting_manager.dart';
import 'package:coffee_bean/scenes/app_setting/app_setting_builder.dart';
import 'package:coffee_bean/scenes/app_setting/interactor/app_setting_event_state.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/utils/language_utils.dart';
import 'package:db_core/db_core.dart';

class AppSettingInteractor extends CubitInteractor<AppSettingRoutable, AppSettingState> {
  AppSettingInteractor({required AppSettingRoutable router})
      : super(
          AppSettingInitial(
            selectedLanguage: AppSettingManager.currentLanguage,
            selectedCurrency: AppSettingManager.currentCurrency,
          ),
          router: router,
        );

  void onLanguageChanged(Language lang) {
    emit(state.copyWith(selectedLanguage: lang));
  }

  void onCurrencyChanged(Currency currency) {
    emit(state.copyWith(selectedCurrency: currency));
  }

  Future<void> performUpdate() async {
    emit(state.copyWith(isSubmitting: true));
    try {
      dLog("AppSettingInteractor: Calling AppSettingManager().updateSettings");
      await AppSettingManager().updateSettings(
        lang: state.selectedLanguage,
        currency: state.selectedCurrency,
      );
      dLog("AppSettingInteractor: AppSettingManager().updateSettings completed");
    } catch (e) {
      dLog("AppSettingInteractor: Update settings failed: $e");
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
