import 'package:coffee_bean/scenes/announcement_detail/interactor/announcement_detail_event_state.dart';
import 'package:coffee_bean/scenes/announcement_detail/interactor/announcement_detail_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:coffee_bean/utils/utils_datetime.dart';

class AnnouncementDetailPage extends AppCubitStateFulWidget<AnnouncementDetailInteractor, AnnouncementDetailState> {
  AnnouncementDetailPage({super.key, required super.interactor});

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends AppCubitState<AnnouncementDetailPage, AnnouncementDetailInteractor, AnnouncementDetailState> {
  
  @override
  String? getTitle() => interactor.state.announcement?.title ?? "Thông báo";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<AnnouncementDetailInteractor, AnnouncementDetailState>(
      builder: (context, state) {
        final announcement = state.announcement;
        
        if (announcement == null && state.isLoading) {
          return getLoadingView();
        }
        
        if (announcement == null) {
          return getEmptyItemView(caption: "Không tìm thấy nội dung thông báo");
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement.title,
                style: TMLabsTextStyle.h2.copyWith(
                  color: TMLabsColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (announcement.createTime != null)
                Text(
                  UtcUtils.formatTimestamp(announcement.createTime!),
                  style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Html(
                data: announcement.content,
                style: {
                  "body": Style(
                    fontSize: FontSize(14),
                    color: TMLabsColor.primary,
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
