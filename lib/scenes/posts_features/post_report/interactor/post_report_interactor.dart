import 'dart:convert';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/posts_features/post_report/interactor/post_report_event_state.dart';
import 'package:coffee_bean/scenes/posts_features/post_report/post_report_builder.dart';
import 'package:db_core/db_core.dart';

class PostReportInteractor extends CubitInteractor<PostReportRoutable, PostReportState> {
  final ReportTargetInfo targetInfo;
  final HubRepository _hubRepository = locator<HubRepository>();

  final List<String> reportReasons = [
    'Thông tin sai sự thật',
    'Vi phạm bản quyền/Đạo văn',
    'Spam/Quảng cáo rác',
    'Nội dung khiêu dâm',
    'Công kích cá nhân',
    'Ngôn từ thù ghét',
    'Lừa đảo',
    'Nội dung độc hại',
    'Nội dung vi phạm pháp luật',
  ];

  PostReportInteractor(
    PostReportRoutable router, {
    required this.targetInfo,
  }) : super(PostReportState(), router: router);

  void onReasonSelected(List<int> indexes) {
    emit(state.copyWith(selectedReasonIndexes: indexes));
  }

  void onDescriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  Future<void> submitReport() async {
    if (state.selectedReasonIndexes.isEmpty && state.description.trim().isEmpty) {
      // Có thể thông báo yêu cầu chọn lý do hoặc nhập mô tả
      return;
    }

    emit(state.copyWith(isLoading: true, failure: null));

    final selectedLabels = state.selectedReasonIndexes.map((i) => reportReasons[i]).toList();
    final reportReasonJson = jsonEncode({
      'reasons': selectedLabels,
      'content': state.description,
    });

    final result = await _hubRepository.createReport(
      targetId: targetInfo.targetId,
      targetType: targetInfo.type.value,
      reportReason: reportReasonJson,
    );

    if (result case DbSuccess()) {
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } else if (result case DbFailure()) {
      emit(state.copyWith(isLoading: false, failure: result));
    }
  }
}
