import 'dart:convert';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/data/repository/infra_repository.dart';
import 'package:coffee_bean/scenes/expert_apply/expert_apply_builder.dart';
import 'package:coffee_bean/scenes/expert_apply/interactor/expert_apply_event_state.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:db_core/db_core.dart';
import 'dart:io';

class ExpertApplyInteractor extends CubitInteractor<ExpertApplyRoutable, ExpertApplyState> {
  final HubRepository _hubRepo = locator.get<HubRepository>();
  final InfraRepository _infraRepo = locator.get<InfraRepository>();

  ExpertApplyInteractor(ExpertApplyRoutable router) : super(ExpertApplyState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    fetchApplication();
  }

  Future<void> fetchApplication() async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _hubRepo.getMyExpertApply();

    if (result case DbSuccess(data: final app)) {
      emit(state.copyWith(application: app, isLoading: false));
    } else {
      // Khi fetch trạng thái lúc vào màn hình, nếu lỗi (mạng/server)
      // ta ngầm định coi như chưa có hồ sơ để hiện Form, không hiện thông báo lỗi gây phiền user.
      emit(state.copyWith(application: null, isLoading: false ));
    }
  }

  void onNameChanged(String val) => emit(state.copyWith(name: val, validation: state.validation.copyWith(isNameValid: true)));
  
  void onPhoneChanged(String countryCode, String number, bool isValid) {
    emit(state.copyWith(
      countryCode: countryCode,
      phone: number,
      isPhoneValid: isValid,
      validation: state.validation.copyWith(isPhoneValid: true),
    ));
  }

  void onEmailChanged(String val) => emit(state.copyWith(email: val, validation: state.validation.copyWith(isEmailValid: true)));
  void onReasonChanged(String val) => emit(state.copyWith(reason: val, validation: state.validation.copyWith(isReasonValid: true)));
  void onDescChanged(String val) => emit(state.copyWith(desc: val));

  void onImagesPicked(List<String> paths) {
    emit(state.copyWith(images: [...state.images, ...paths]));
  }

  void removeImage(int index) {
    final newList = List<String>.from(state.images)..removeAt(index);
    emit(state.copyWith(images: newList));
  }

  bool validate() {
    final isNameValid = state.name.trim().isNotEmpty;
    final isPhoneValid = state.phone.trim().isNotEmpty && state.isPhoneValid;
    final isReasonValid = state.reason.trim().isNotEmpty;
    
    // Email không bắt buộc, nhưng nếu nhập thì phải đúng định dạng
    bool isEmailValid = true;
    if (state.email.trim().isNotEmpty) {
      isEmailValid = Utils.isEmailAddress(state.email);
    }

    emit(state.copyWith(
      validation: ExpertApplyFormStatus(
        isNameValid: isNameValid,
        isPhoneValid: isPhoneValid,
        isReasonValid: isReasonValid,
        isEmailValid: isEmailValid,
      ),
    ));

    return isNameValid && isPhoneValid && isReasonValid && isEmailValid;
  }

  Future<void> submitApplication() async {
    if (!validate()) return;

    emit(state.copyWith(isSubmitting: true, clearFailure: true, isLoading: true));

    // 1. Upload images if any
    List<String> uploadedUrls = [];
    if (state.images.isNotEmpty) {
      for (final path in state.images) {
        final uploadResult = await _infraRepo.uploadFile(File(path), directory: 'expert_apply');
        if (uploadResult case DbSuccess(data: final url)) {
          uploadedUrls.add(url);
        } else {
          emit(state.copyWith(isSubmitting: false, failure: uploadResult as DbFailure));
          return;
        }
      }
    }

    // 2. Submit application
    final Dictionary params = {
      'applyName': state.name,
      'applyPhone': '${state.countryCode}${state.phone}',
      'applyEmail': state.email,
      'applyReason': state.reason,
      'applyDesc': state.desc,
      'applyImgs': uploadedUrls.isNotEmpty ? jsonEncode(uploadedUrls) : null,
    };

    final result = await _hubRepo.submitExpertApply(params);
    if (result is DbSuccess) {
      // Refresh to show pending status
      await fetchApplication();
    } else {
      emit(state.copyWith(isSubmitting: false, failure: result as DbFailure));
    }
  }

  void onReApply() {
    emit(state.copyWith(clearApplication: true, name: '', phone: '', reason: '', desc: '', images: [], email: ''));
  }

}
