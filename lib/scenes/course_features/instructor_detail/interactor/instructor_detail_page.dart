import 'package:coffee_bean/data/model/response/hub/instructor_info.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:coffee_bean/scenes/course_features/instructor_detail/interactor/instructor_detail_interactor.dart';
import 'package:coffee_bean/scenes/course_features/instructor_detail/interactor/instructor_detail_event_state.dart';

class InstructorDetailPage extends AppCubitStateFulWidget<InstructorDetailInteractor, InstructorDetailState> {
  InstructorDetailPage({super.key, required super.interactor});

  @override
  State<InstructorDetailPage> createState() => _InstructorDetailPageState();
}

class _InstructorDetailPageState extends AppCubitState<InstructorDetailPage, InstructorDetailInteractor, InstructorDetailState> {
  
  @override
  String? getTitle() => 'Chi Tiết Giảng Viên';

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<InstructorDetailInteractor, InstructorDetailState>(
      builder: (context, state) {
        final instructor = state.instructor;
        if (instructor == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildMainInfoCard(instructor),
              const SizedBox(height: 16),
              _buildRichTextCard(instructor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainInfoCard(InstructorInfo instructor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AvatarWidget(imageUrl: instructor.instructorAvatar, size: 80),
          const SizedBox(height: 16),
          Text(
            instructor.instructorName ?? '--',
            style: TMLabsTextStyle.h2.copyWith(fontWeight: FontWeight.bold),
          ),
          if (instructor.instructorTitle != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: TMLabsColor.bgLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                instructor.instructorTitle!,
                style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRichTextCard(InstructorInfo instructor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TMLabsColor.lightGrey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Html(
            data: instructor.instructorDesc ?? '',
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(14),
                color: TMLabsColor.grey,
              ),
            },
          ),
          if (instructor.instructorDesc == null || instructor.instructorDesc!.isEmpty)
             const Center(
               child: Padding(
                 padding: EdgeInsets.symmetric(vertical: 40),
                 child: Text('Chưa có thông tin mô tả chi tiết'),
               ),
             ),
        ],
      ),
    );
  }
}
