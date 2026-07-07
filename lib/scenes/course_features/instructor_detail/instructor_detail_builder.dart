import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/scenes/course_features/instructor_detail/interactor/instructor_detail_interactor.dart';
import 'package:coffee_bean/scenes/course_features/instructor_detail/interactor/instructor_detail_page.dart';


// ROUTABLE
abstract class InstructorDetailRoutable implements DbNoteRoutable {}

// -- ROUTER --
class InstructorDetailRouter extends DbNoteRouter implements InstructorDetailRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }
}

class InstructorDetailBuilder extends DbNoteBuilder<InstructorDetailRouter> {
  final int instructorId;

  InstructorDetailBuilder({required this.instructorId});

  @override
  InstructorDetailRouter build() {
    final router = InstructorDetailRouter();
    final interactor = InstructorDetailInteractor(router, instructorId: instructorId);
    final page = InstructorDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
