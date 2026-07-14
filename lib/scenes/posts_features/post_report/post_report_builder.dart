import 'package:coffee_bean/scenes/posts_features/post_report/interactor/post_report_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_report/interactor/post_report_page.dart';
import 'package:db_core/db_core.dart';

enum ReportTargetType {
  post(1),
  comment(2);

  final int value;
  const ReportTargetType(this.value);
}

class ReportTargetInfo {
  final ReportTargetType type;
  final int targetId;
  final String? nickname;
  final String? imageUrl;
  final String? summary;

  ReportTargetInfo({
    required this.type,
    required this.targetId,
    this.nickname,
    this.imageUrl,
    this.summary,
  });
}

// ROUTER
abstract class PostReportRoutable implements DbNoteRoutable {}

class PostReportRouter extends DbNoteRouter implements PostReportRoutable {
}

// BUILDER
class PostReportBuilder extends DbNoteBuilder<PostReportRouter> {
  final ReportTargetInfo targetInfo;

  PostReportBuilder({
    required this.targetInfo,
  });

  @override
  PostReportRouter build() {
    final router = PostReportRouter();
    final interactor = PostReportInteractor(
      router,
      targetInfo: targetInfo,
    );
    final page = PostReportPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
