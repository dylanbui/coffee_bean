import 'dart:async';
import 'package:coffee_bean/data/local/settings_app_manager/settings_app_manager.dart';
import 'package:coffee_bean/scenes/settings_app/settings_app_builder.dart';
import 'package:coffee_bean/scenes/settings_app/interactor/settings_app_event_state.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/utils/language_utils.dart';
import 'package:db_core/db_core.dart';

class SettingsAppInteractor extends CubitInteractor<SettingsAppRoutable, SettingsAppState> {
  SettingsAppInteractor({required SettingsAppRoutable router})
      : super(
          SettingsAppInitial(
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
      dLog("SettingsAppInteractor: Calling SettingsAppManager().updateSettings");
      await SettingsAppManager().updateSettings(
        lang: state.selectedLanguage,
        currency: state.selectedCurrency,
      );
      dLog("SettingsAppInteractor: SettingsAppManager().updateSettings completed");
    } catch (e) {
      dLog("SettingsAppInteractor: Update settings failed: $e");
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
