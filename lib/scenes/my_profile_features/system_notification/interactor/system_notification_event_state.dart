import 'package:coffee_bean/data/model/response/system/notify_message.dart';
import 'package:db_core/db_core.dart';

class SystemNotificationState extends BaseBlocState {
  final bool isLoading;
  final DbFailure? failure;
  final Map<String, List<NotifyMessage>> groupedMessages;
  final int unreadCount;
  final Set<int> expandedIds;

  SystemNotificationState({
    this.isLoading = false,
    this.failure,
    this.groupedMessages = const {},
    this.unreadCount = 0,
    this.expandedIds = const {},
  });

  SystemNotificationState copyWith({
    bool? isLoading,
    DbFailure? failure,
    Map<String, List<NotifyMessage>>? groupedMessages,
    int? unreadCount,
    Set<int>? expandedIds,
  }) {
    return SystemNotificationState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
      groupedMessages: groupedMessages ?? this.groupedMessages,
      unreadCount: unreadCount ?? this.unreadCount,
      expandedIds: expandedIds ?? this.expandedIds,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        failure,
        groupedMessages,
        unreadCount,
        expandedIds,
      ];
}
