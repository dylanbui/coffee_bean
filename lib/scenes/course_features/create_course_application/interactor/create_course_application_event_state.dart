import 'package:db_core/db_core.dart';

class CreateCourseApplicationFormStatus extends Equatable {
  final bool isNameValid;
  final bool isTypeValid;
  final bool isFeeValid;

  const CreateCourseApplicationFormStatus({
    this.isNameValid = true,
    this.isTypeValid = true,
    this.isFeeValid = true,
  });

  bool get isValid => isNameValid && isTypeValid && isFeeValid;

  @override
  List<Object?> get props => [isNameValid, isTypeValid, isFeeValid];

  CreateCourseApplicationFormStatus copyWith({
    bool? isNameValid,
    bool? isTypeValid,
    bool? isFeeValid,
  }) {
    return CreateCourseApplicationFormStatus(
      isNameValid: isNameValid ?? this.isNameValid,
      isTypeValid: isTypeValid ?? this.isTypeValid,
      isFeeValid: isFeeValid ?? this.isFeeValid,
    );
  }
}

class CreateCourseApplicationState extends BaseBlocState {
  final bool isLoading;
  final String name;
  final String? selectedType; // Dùng String cho đơn giản, hoặc Object nếu có model
  final String fee;
  final String introduction;
  final List<String> images;
  final DbFailure? failure;
  final bool isSubmitting;
  final CreateCourseApplicationFormStatus validation;

  CreateCourseApplicationState({
    this.isLoading = false,
    this.name = '',
    this.selectedType,
    this.fee = '',
    this.introduction = '',
    this.images = const [],
    this.failure,
    this.isSubmitting = false,
    this.validation = const CreateCourseApplicationFormStatus(),
  });

  @override
  List<Object?> get props => [
        isLoading,
        name,
        selectedType,
        fee,
        introduction,
        images,
        failure,
        isSubmitting,
        validation,
      ];

  CreateCourseApplicationState copyWith({
    bool? isLoading,
    String? name,
    String? selectedType,
    String? fee,
    String? introduction,
    List<String>? images,
    DbFailure? failure,
    bool? isSubmitting,
    CreateCourseApplicationFormStatus? validation,
  }) {
    return CreateCourseApplicationState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      selectedType: selectedType ?? this.selectedType,
      fee: fee ?? this.fee,
      introduction: introduction ?? this.introduction,
      images: images ?? this.images,
      failure: failure ?? this.failure,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      validation: validation ?? this.validation,
    );
  }
}
