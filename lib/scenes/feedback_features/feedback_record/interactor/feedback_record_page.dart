import 'package:coffee_bean/data/model/response/hub/feedback_info.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_record/feedback_record_builder.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_record/interactor/feedback_record_interactor.dart';
import 'package:coffee_bean/scenes/feedback_features/feedback_record/interactor/feedback_record_event_state.dart';

class FeedbackRecordPage extends AppCubitStateFulWidget<FeedbackRecordInteractor, FeedbackRecordState> {
  FeedbackRecordPage({super.key, required super.interactor});

  @override
  State<FeedbackRecordPage> createState() => _FeedbackRecordPageState();
}

class _FeedbackRecordPageState extends AppCubitState<FeedbackRecordPage, FeedbackRecordInteractor, FeedbackRecordState> {
  @override
  String? getTitle() => "Lịch sử phản hồi";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<FeedbackRecordInteractor, FeedbackRecordState>(
      builder: (context, state) {
        if (state.isLoading && state.feedbacks.isEmpty) {
          return getLoadingView();
        }

        if (state.feedbacks.isEmpty) {
          return getEmptyItemView(caption: "Bạn chưa có phản hồi nào.");
        }

        return RefreshIndicator(
          onRefresh: interactor.fetchFeedbacks,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.feedbacks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = state.feedbacks[index];
              return _buildFeedbackItem(item);
            },
          ),
        );
      },
    );
  }

  Widget _buildFeedbackItem(FeedbackInfo item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => {
          interactor.router?.navigate(FeedbackDetailRoute(item.id))
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.feedbackContent ?? "",
                    style: TMLabsTextStyle.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.displayCreateTime,
                    style: TMLabsTextStyle.caption.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
