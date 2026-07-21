import 'package:coffee_bean/data/model/response/user/invite_models.dart';
import 'package:db_core/db_core.dart';

class InvitationRecordState extends BaseBlocState {
  final bool isLoading;
  final bool isMoreLoading;
  final List<InviteRecord> records;
  final int total;
  final int pageNo;
  final DbFailure? failure;

  InvitationRecordState({
    this.isLoading = false,
    this.isMoreLoading = false,
    this.records = const [],
    this.total = 0,
    this.pageNo = 1,
    this.failure,
  });

  bool get canLoadMore => records.length < total;

  InvitationRecordState copyWith({
    bool? isLoading,
    bool? isMoreLoading,
    List<InviteRecord>? records,
    int? total,
    int? pageNo,
    DbFailure? failure,
  }) {
    return InvitationRecordState(
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      records: records ?? this.records,
      total: total ?? this.total,
      pageNo: pageNo ?? this.pageNo,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [isLoading, isMoreLoading, records, total, pageNo, failure];
}
