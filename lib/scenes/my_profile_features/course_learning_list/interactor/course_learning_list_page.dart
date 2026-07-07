import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/interactor/course_learning_list_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/interactor/course_learning_list_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseLearningListPage extends AppCubitStateFulWidget<CourseLearningListInteractor, CourseLearningListState> {
  CourseLearningListPage({super.key, required super.interactor});

  @override
  State<CourseLearningListPage> createState() => _CourseLearningListPageState();
}

class _CourseLearningListPageState extends AppCubitState<CourseLearningListPage, CourseLearningListInteractor, CourseLearningListState> {
  
  @override
  String? getTitle() => "Khóa học của tôi";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<CourseLearningListInteractor, CourseLearningListState>(
      builder: (context, state) {
        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, CourseLearningListState state) {
    if (state.isLoading && state.items.isEmpty) {
      return FadeSwitcher(stateKey: "getLoadingView", child: getLoadingView());
    }

    if (state.items.isEmpty) {
      return FadeSwitcher(
        stateKey: "getEmptyItemView", 
        child: getEmptyItemView(caption: "Bạn chưa tham gia khóa học nào !"),
      );
    }

    final content = ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildCourseItem(state.items[index]),
    );

    return FadeSwitcher(stateKey: "content_${state.items.length}", child: content);
  }

  Widget _buildCourseItem(CourseLearningProgressModel item) {
    return TapEffect(
      onTap: () => interactor.onCourseTap(item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            DbCachedImageWidget(
              imageUrl: item.course.mainImage,
              width: 100,
              height: 80,
              borderRadius: 8,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.course.courseName,
                    style: TMLabsTextStyle.bodyBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.course.courseDesc ?? "",
                    style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                      children: [
                        const TextSpan(text: "Tiến độ: "),
                        TextSpan(
                          text: "${item.completedLessons}/${item.course.courseLessons}",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
