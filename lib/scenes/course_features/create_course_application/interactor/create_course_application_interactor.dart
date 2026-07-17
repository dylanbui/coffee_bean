import 'package:coffee_bean/scenes/course_features/create_course_application/create_course_application_builder.dart';
import 'package:coffee_bean/scenes/course_features/create_course_application/interactor/create_course_application_event_state.dart';
import 'package:db_core/db_core.dart';

class CreateCourseApplicationInteractor extends CubitInteractor<CreateCourseApplicationRoutable, CreateCourseApplicationState> {
  CreateCourseApplicationInteractor(CreateCourseApplicationRoutable router)
      : super(CreateCourseApplicationState(), router: router);

  void onNameChanged(String value) {
    emit(state.copyWith(
      name: value,
      validation: state.validation.copyWith(isNameValid: true),
    ));
  }

  void onFeeChanged(String value) {
    emit(state.copyWith(
      fee: value,
      validation: state.validation.copyWith(isFeeValid: true),
    ));
  }

  void onIntroChanged(String value) {
    emit(state.copyWith(introduction: value));
  }

  void onTypeSelected(String type) {
    emit(state.copyWith(
      selectedType: type,
      validation: state.validation.copyWith(isTypeValid: true),
    ));
  }

  void onImagesPicked(List<String> paths) {
    final List<String> updatedImages = List.from(state.images)..addAll(paths);
    emit(state.copyWith(images: updatedImages));
  }

  void removeImage(int index) {
    final List<String> updatedImages = List.from(state.images)..removeAt(index);
    emit(state.copyWith(images: updatedImages));
  }

  void submit() {
    final isNameValid = state.name.isNotEmpty;
    final isTypeValid = state.selectedType != null;
    final isFeeValid = state.fee.isNotEmpty;

    final validation = state.validation.copyWith(
      isNameValid: isNameValid,
      isTypeValid: isTypeValid,
      isFeeValid: isFeeValid,
    );

    emit(state.copyWith(validation: validation));

    if (validation.isValid) {
      _performSubmit();
    } else {
      iLog("Form không hợp lệ");
    }
  }

  void _performSubmit() {
    // Tạo Dictionary dữ liệu để gửi API sau này
    final Dictionary data = {
      'course_name': state.name,
      'course_type': state.selectedType,
      'course_fee': state.fee,
      'introduction': state.introduction,
      'images': state.images,
    };

    iLog("Dữ liệu đăng ký khóa học: $data");
    
    // Giả lập gửi thành công
    emit(state.copyWith(isSubmitting: true));
    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(isSubmitting: false));
      // router.pop(); // Hoặc thông báo thành công
    });
  }
}
