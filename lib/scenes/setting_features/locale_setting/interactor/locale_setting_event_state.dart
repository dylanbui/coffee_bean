import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/utils/language_utils.dart';
import 'package:db_core/db_core.dart';

abstract class LocaleSettingState extends BaseBlocState with EquatableMixin {
  final Language selectedLanguage;
  final Currency selectedCurrency;
  final bool isSubmitting;

  LocaleSettingState({
    required this.selectedLanguage,
    required this.selectedCurrency,
    this.isSubmitting = false,
  });

  LocaleSettingState copyWith({
    Language? selectedLanguage,
    Currency? selectedCurrency,
    bool? isSubmitting,
  }) {
    return LocaleSettingInitial(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [selectedLanguage, selectedCurrency, isSubmitting];
}

class LocaleSettingInitial extends LocaleSettingState {
  LocaleSettingInitial({
    required super.selectedLanguage,
    required super.selectedCurrency,
    super.isSubmitting,
  });
}
