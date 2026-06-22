import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean/utils/language_utils.dart';
import 'package:db_core/db_core.dart';
import 'package:equatable/equatable.dart';

abstract class AppSettingState extends BaseBlocState with EquatableMixin {
  final Language selectedLanguage;
  final Currency selectedCurrency;
  final bool isSubmitting;

  AppSettingState({
    required this.selectedLanguage,
    required this.selectedCurrency,
    this.isSubmitting = false,
  });

  AppSettingState copyWith({
    Language? selectedLanguage,
    Currency? selectedCurrency,
    bool? isSubmitting,
  }) {
    return AppSettingInitial(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [selectedLanguage, selectedCurrency, isSubmitting];
}

class AppSettingInitial extends AppSettingState {
  AppSettingInitial({
    required super.selectedLanguage,
    required super.selectedCurrency,
    super.isSubmitting,
  });
}
