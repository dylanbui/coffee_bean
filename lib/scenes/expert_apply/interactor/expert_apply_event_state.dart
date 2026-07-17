import 'package:coffee_bean/data/model/response/hub/expert_apply.dart';
import 'package:db_core/db_core.dart';

class ExpertApplyFormStatus extends Equatable {
  final bool isNameValid;
  final bool isPhoneValid;
  final bool isReasonValid;
  final bool isEmailValid;

  const ExpertApplyFormStatus({
    this.isNameValid = true,
    this.isPhoneValid = true,
    this.isReasonValid = true,
    this.isEmailValid = true,
  });

  bool get hasError => !isNameValid || !isPhoneValid || !isReasonValid || !isEmailValid;

  @override
  List<Object?> get props => [isNameValid, isPhoneValid, isReasonValid, isEmailValid];

  ExpertApplyFormStatus copyWith({
    bool? isNameValid,
    bool? isPhoneValid,
    bool? isReasonValid,
    bool? isEmailValid,
  }) {
    return ExpertApplyFormStatus(
      isNameValid: isNameValid ?? this.isNameValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isReasonValid: isReasonValid ?? this.isReasonValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}

class ExpertApplyState extends BaseBlocState {
  final bool isLoading;
  final ExpertApply? application; // Dữ liệu hồ sơ hiện tại
  
  // Form fields
  final String name;
  final String phone;
  final String countryCode;
  final String email;
  final String reason;
  final String desc; // Ghi chú
  final List<String> images;
  final bool isPhoneValid; // Từ widget PhoneInputField
  
  final bool isSubmitting;
  final ExpertApplyFormStatus validation;
  final DbFailure? failure;

  ExpertApplyState({
    this.isLoading = true,
    this.application,
    this.name = '',
    this.phone = '',
    this.countryCode = '+84',
    this.email = '',
    this.reason = '',
    this.desc = '',
    this.images = const [],
    this.isPhoneValid = false,
    this.isSubmitting = false,
    this.validation = const ExpertApplyFormStatus(),
    this.failure,
  });

  @override
  List<Object?> get props => [
        isLoading,
        application,
        name,
        phone,
        countryCode,
        email,
        reason,
        desc,
        images,
        isPhoneValid,
        isSubmitting,
        validation,
        failure,
      ];

  ExpertApplyState copyWith({
    bool? isLoading,
    ExpertApply? application,
    String? name,
    String? phone,
    String? countryCode,
    String? email,
    String? reason,
    String? desc,
    List<String>? images,
    bool? isPhoneValid,
    bool? isSubmitting,
    ExpertApplyFormStatus? validation,
    DbFailure? failure,
    bool clearFailure = false,
    bool clearApplication = false,
  }) {
    return ExpertApplyState(
      isLoading: isLoading ?? this.isLoading,
      application: clearApplication ? null : (application ?? this.application),
      name: name ?? this.name,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      reason: reason ?? this.reason,
      desc: desc ?? this.desc,
      images: images ?? this.images,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      validation: validation ?? this.validation,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
