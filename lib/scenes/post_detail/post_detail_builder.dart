import 'package:coffee_bean/scenes/post_detail/interactor/post_detail_interactor.dart';
import 'package:coffee_bean/scenes/post_detail/interactor/post_detail_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/problem_report/problem_report_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class PostDetailRoutable implements DbNoteRoutable {
  void openProblemReport();
}

class PostDetailRouter extends DbNoteRouter implements PostDetailRoutable {
  @override
  void openProblemReport() {
    final builder = ProblemReportBuilder();
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
