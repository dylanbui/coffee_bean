import 'package:db_core/db_core.dart';

class PostReportState extends BaseBlocState with EquatableMixin {
  final bool isLoading;
  final List<int> selectedReasonIndexes;
  final String description;
  final DbFailure? failure;
  final bool isSuccess;

  PostReportState({
    this.isLoading = false,
    this.selectedReasonIndexes = const [],
    this.description = '',
    this.failure,
    this.isSuccess = false,
  });

  @override
  List<Object?> get props => [isLoading, selectedReasonIndexes, description, failure, isSuccess];

  PostReportState copyWith({
    bool? isLoading,
    List<int>? selectedReasonIndexes,
    String? description,
    DbFailure? failure,
    bool? isSuccess,
  }) {
    return PostReportState(
      isLoading: isLoading ?? this.isLoading,
      selectedReasonIndexes: selectedReasonIndexes ?? this.selectedReasonIndexes,
      description: description ?? this.description,
      failure: failure ?? this.failure,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
