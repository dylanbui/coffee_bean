import 'package:coffee_bean/scenes/posts_features/post_detail/interactor/post_detail_interactor.dart';
import 'package:coffee_bean/scenes/posts_features/post_detail/interactor/post_detail_page.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/posts_features/post_report/post_report_builder.dart';

abstract class PostDetailRoutable implements DbNoteRoutable {
  void openReportPost({
    required ReportTargetInfo targetInfo,
  });
}

class PostDetailRouter extends DbNoteRouter implements PostDetailRoutable {
  @override
  void openReportPost({
    required ReportTargetInfo targetInfo,
  }) {
    final builder = PostReportBuilder(
      targetInfo: targetInfo,
    );
    push(builder.build().viewController);
  }
}


class PostDetailBuilder extends DbNoteBuilder<PostDetailRouter> {
  final int postId;

  PostDetailBuilder({required this.postId});

  @override
  PostDetailRouter build() {
    final router = PostDetailRouter();
    final interactor = PostDetailInteractor(router, postId: postId);
    final page = PostDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
