import 'package:coffee_bean/data/model/response/system/notify_message.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:coffee_bean/data/repository/system_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/system_notification/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/my_profile_features/system_notification/interactor/system_notification_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/system_notification/system_notification_builder.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:db_core/db_core.dart';

class SystemNotificationInteractor extends CubitInteractor<SystemNotificationRoutable, SystemNotificationState> {
  final SystemRepository _repository = locator.get<SystemRepository>();

  SystemNotificationInteractor(SystemNotificationRoutable router)
      : super(SystemNotificationState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    refreshData();
  }

  Future<void> refreshData() async {
    emit(state.copyWith(isLoading: true, failure: null));

    // Fetch unread count and messages in parallel
    final results = await Future.wait([
      _repository.getUnreadNotifyMessageCount(),
      _repository.getNotifyMessagePage(pageSize: 100), // Get a good amount for grouping
    ]);

    final unreadResult = results[0] as DbResult<int>;
    final messagesResult = results[1] as ResultPageType<NotifyMessage>;

    int unreadCount = 0;
    if (unreadResult case DbSuccess(data: final count)) {
      unreadCount = count;
    }

    if (messagesResult case DbSuccess(data: final pageData)) {
      if (pageData.list.isEmpty) {
        // Nếu server trả về rỗng, dùng dữ liệu mock để test UI
        iLog("API returned empty list, falling back to mock data");
        _processMessages(mockNotifyMessages, mockNotifyMessages.where((e) => !e.readStatus).length);
      } else {
        _processMessages(pageData.list, unreadCount);
      }
    } else if (messagesResult case DbFailure(:final error)) {
      // Fallback to mock data as requested
      iLog("API Error, falling back to mock data: $error");
      _processMessages(mockNotifyMessages, mockNotifyMessages.where((e) => !e.readStatus).length);
    }
  }

  void _processMessages(List<NotifyMessage> messages, int unreadCount) {
    final grouped = _groupMessages(messages);
    emit(state.copyWith(
      isLoading: false,
      groupedMessages: grouped,
      unreadCount: unreadCount,
    ));
  }

  Map<String, List<NotifyMessage>> _groupMessages(List<NotifyMessage> messages) {
    final Map<String, List<NotifyMessage>> groups = {
      "Hôm nay": [],
      "Hôm qua": [],
      "7 ngày qua": [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var msg in messages) {
      final createTime = UtcUtils.toDateTimeSafe(msg.createTime);
      if (createTime == null) continue;
      
      final msgDate = DateTime(createTime.year, createTime.month, createTime.day);
      if (msgDate == today) {
        groups["Hôm nay"]!.add(msg);
      } else if (msgDate == yesterday) {
        groups["Hôm qua"]!.add(msg);
      } else {
        groups["7 ngày qua"]!.add(msg);
      }
    }

    // Remove empty groups
    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  void toggleExpand(int id) {
    final newExpandedIds = Set<int>.from(state.expandedIds);
    if (newExpandedIds.contains(id)) {
      newExpandedIds.remove(id);
    } else {
      newExpandedIds.add(id);
      // Mark as read when expanded if not already read
      final allMessages = state.groupedMessages.values.expand((e) => e).toList();
      final msg = allMessages.firstWhere((e) => e.id == id);
      if (!msg.readStatus) {
        markAsRead(id);
      }
    }
    emit(state.copyWith(expandedIds: newExpandedIds));
  }

  Future<void> markAsRead(int id) async {
    // Optimistic update
    final allMessages = state.groupedMessages.values.expand((e) => e).toList();
    final msg = allMessages.firstWhere((e) => e.id == id);
    if (!msg.readStatus) {
      _updateMessageReadStatus(id, true);
      // Decrement unread count locally
      emit(state.copyWith(unreadCount: (state.unreadCount - 1).clamp(0, 9999)));
    }

    final result = await _repository.updateNotifyMessageRead([id]);
    if (result case DbFailure()) {
      // Revert if failed
      _updateMessageReadStatus(id, false);
      // We don't necessarily know the exact count to revert to if multiple actions happened,
      // so we fetch from server to be sure.
      _fetchUnreadCount();
    }
  }

  Future<void> markAllAsRead() async {
    final result = await _repository.updateAllNotifyMessageRead();
    if (result case DbSuccess()) {
      refreshData();
    }
  }

  Future<void> deleteMessage(int id) async {
    final result = await _repository.deleteNotifyMessage([id]);
    if (result case DbSuccess()) {
      refreshData();
    }
  }

  void _updateMessageReadStatus(int id, bool isRead) {
    final Map<String, List<NotifyMessage>> newGroups = {};
    
    state.groupedMessages.forEach((key, messages) {
      final List<NotifyMessage> newList = List.from(messages);
      final index = newList.indexWhere((e) => e.id == id);
      if (index != -1) {
        final oldMsg = newList[index];
        newList[index] = NotifyMessage(
          id: oldMsg.id,
          userId: oldMsg.userId,
          userType: oldMsg.userType,
          templateId: oldMsg.templateId,
          templateCode: oldMsg.templateCode,
          templateNickname: oldMsg.templateNickname,
          templateContent: oldMsg.templateContent,
          templateType: oldMsg.templateType,
          templateParams: oldMsg.templateParams,
          readStatus: isRead,
          createTime: oldMsg.createTime,
          readTime: isRead ? DateTime.now().millisecondsSinceEpoch : null,
        );
      }
      newGroups[key] = newList;
    });
    
    emit(state.copyWith(groupedMessages: newGroups));
  }

  Future<void> _fetchUnreadCount() async {
    final result = await _repository.getUnreadNotifyMessageCount();
    if (result case DbSuccess(data: final count)) {
      emit(state.copyWith(unreadCount: count));
    }
  }
}
