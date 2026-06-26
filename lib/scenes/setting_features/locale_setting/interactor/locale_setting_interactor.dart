import 'dart:async';
import 'package:coffee_bean/data/local/settings_app_manager/settings_app_manager.dart';
import 'package:coffee_bean/scenes/setting_features/locale_setting/locale_setting_builder.dart';
import 'package:coffee_bean/scenes/setting_features/locale_setting/interactor/locale_setting_event_state.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/utils/language_utils.dart';
import 'package:db_core/db_core.dart';

class LocaleSettingInteractor extends CubitInteractor<LocaleSettingRoutable, LocaleSettingState> {
  LocaleSettingInteractor({required LocaleSettingRoutable router})
      : super(
          LocaleSettingInitial(
            selectedLanguage: SettingsAppManager.currentLanguage,
            selectedCurrency: SettingsAppManager.currentCurrency,
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
      await SettingsAppManager().updateSettings(
        lang: state.selectedLanguage,
        currency: state.selectedCurrency,
      );
    } catch (e) {
      dLog("LocaleSettingInteractor: Update settings failed: $e");
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
