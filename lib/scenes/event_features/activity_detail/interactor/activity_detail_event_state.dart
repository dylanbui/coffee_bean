import 'package:coffee_bean/data/model/response/hub/activity_info_detail.dart';
import 'package:equatable/equatable.dart';

class ActivityDetailState extends Equatable {
  final bool isLoading;
  final ActivityInfoDetail? activityDetail;

  const ActivityDetailState({
    this.isLoading = false,
    this.activityDetail,
  });

  ActivityDetailState copyWith({
    bool? isLoading,
    ActivityInfoDetail? activityDetail,
  }) {
    return ActivityDetailState(
      isLoading: isLoading ?? this.isLoading,
      activityDetail: activityDetail ?? this.activityDetail,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        activityDetail,
      ];
}
