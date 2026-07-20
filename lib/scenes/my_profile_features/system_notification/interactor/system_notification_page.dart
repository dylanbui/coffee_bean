import 'package:coffee_bean/data/model/response/system/notify_message.dart';
import 'package:coffee_bean/scenes/my_profile_features/system_notification/interactor/system_notification_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/system_notification/interactor/system_notification_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SystemNotificationPage extends AppCubitStateFulWidget<SystemNotificationInteractor, SystemNotificationState> {
  SystemNotificationPage({super.key, required super.interactor});

  @override
  State<SystemNotificationPage> createState() => _SystemNotificationPageState();
}

class _SystemNotificationPageState
    extends AppCubitState<SystemNotificationPage, SystemNotificationInteractor, SystemNotificationState> {
  @override
  String? getTitle() => "Thông báo hệ thống";

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return CoffeeAppBar(
      titleWidget: BlocBuilder<SystemNotificationInteractor, SystemNotificationState>(
        buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
        builder: (context, state) {
          final unreadCount = state.unreadCount;
          final titleStyle = getAppBarStyle().titleTextStyle ??
              TextStyle(
                color: getAppBarStyle().foregroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              );

          if (unreadCount <= 0) {
            return Text("Thông báo hệ thống", style: titleStyle);
          }

          final countStr = unreadCount > 99 ? '99+' : '$unreadCount';
          return RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: titleStyle,
              children: [
                const TextSpan(text: "Thông báo hệ thống "),
                TextSpan(
                  text: "($countStr)",
                  style: titleStyle.copyWith(
                    color: TMLabsColor.error,
                    fontSize: titleStyle.fontSize! - 4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: getActions(),
      style: getAppBarStyle(),
      onBackTap: () => interactor.router?.pop(),
    );
  }

  @override
  List<Widget>? getActions() {
    return [
      AppButton(
        text: "Đã đọc",
        style: TMLabsButtonStyle.outline.copyWith(
          textStyle: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.primary),
        ),
        width: 80,
        height: 28,
        onPressed: () => interactor.markAllAsRead(),
      ),
      const SizedBox(width: 16),
    ];
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<SystemNotificationInteractor, SystemNotificationState>(
      builder: (context, state) {
        if (state.isLoading && state.groupedMessages.isEmpty) {
          return getLoadingView();
        }

        if (state.groupedMessages.isEmpty) {
          return getEmptyItemView(caption: "Không có thông báo nào");
        }

        return RefreshIndicator(
          onRefresh: () => interactor.refreshData(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.groupedMessages.length,
            itemBuilder: (context, index) {
              final groupName = state.groupedMessages.keys.elementAt(index);
              final messages = state.groupedMessages[groupName]!;
              return _buildGroup(groupName, messages, state.expandedIds);
            },
          ),
        );
      },
    );
  }

  Widget _buildGroup(String title, List<NotifyMessage> messages, Set<int> expandedIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(title, style: TMLabsTextStyle.title.copyWith(fontWeight: FontWeight.bold)),
        ),
        ...messages.map((msg) => _buildMessageItem(msg, expandedIds.contains(msg.id))),
      ],
    );
  }

  Widget _buildMessageItem(NotifyMessage msg, bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Slidable(
        key: ValueKey(msg.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.4,
          children: [
            if (!msg.readStatus)
              SlidableAction(
                onPressed: (context) => interactor.markAsRead(msg.id),
                backgroundColor: TMLabsColor.success,
                foregroundColor: Colors.white,
                icon: Icons.done_all,
                label: 'Đã đọc',
              ),
            SlidableAction(
              onPressed: (context) => interactor.deleteMessage(msg.id),
              backgroundColor: TMLabsColor.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xóa',
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => interactor.toggleExpand(msg.id),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: msg.readStatus ? Colors.white : TMLabsColor.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: msg.readStatus ? TMLabsColor.lightGrey : TMLabsColor.primary.withValues(alpha: 0.3),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TMLabsTextStyle.body.copyWith(
                                  color: msg.readStatus ? Colors.black87 : TMLabsColor.primary,
                                  fontWeight: msg.readStatus ? FontWeight.normal : FontWeight.bold,
                                ),
                                children: [
                                  const TextSpan(text: "Có "),
                                  TextSpan(
                                    text: msg.templateNickname,
                                    style: const TextStyle(decoration: TextDecoration.underline),
                                  ),
                                  const TextSpan(text: " gửi tin nhắn cho bạn."),
                                ],
                              ),
                            ),
                          ),
                          if (!msg.readStatus)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: AppLabel(
                                "Mới",
                                backgroundColor: TMLabsColor.error,
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                borderRadius: 4,
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildContent(msg.templateContent, msg.readStatus, isExpanded),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  UtcUtils.formatTimestamp(msg.createTime, format: AppDateTimeFormat.fullDatetime),
                                  style: TMLabsTextStyle.caption.copyWith(
                                    color: msg.readStatus ? TMLabsColor.grey : TMLabsColor.primary.withValues(alpha: 0.7),
                                  ),
                                ),
                                if (isExpanded)
                                  Text(
                                    "Thu gọn",
                                    style: TMLabsTextStyle.caption.copyWith(
                                      color: TMLabsColor.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                  color: msg.readStatus ? TMLabsColor.grey : TMLabsColor.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(String content, bool isRead, bool isExpanded) {
    final parts = content.split('**');
    final List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 1) {
        spans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isRead ? Colors.black : TMLabsColor.primary,
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: parts[i]));
      }
    }

    return RichText(
      maxLines: isExpanded ? null : 1,
      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
      text: TextSpan(
        style: TMLabsTextStyle.body.copyWith(
          color: isRead ? Colors.black54 : Colors.black87,
          height: 1.4,
        ),
        children: spans,
      ),
    );
  }
}
