import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/instructor_profile_interactor.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/instructor_profile_page.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

abstract class InstructorProfileRoutable implements DbNoteRoutable {}

// ROUTER
class InstructorProfileRouter extends DbNoteRouter implements InstructorProfileRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Implement navigation if needed
  }
}

// BUILDER
class InstructorProfileBuilder extends DbNoteBuilder<InstructorProfileRouter> {
  final int instructorId;

  InstructorProfileBuilder({required this.instructorId});

  @override
  InstructorProfileRouter build() {
    final router = InstructorProfileRouter();
    final interactor = InstructorProfileInteractor(router, instructorId);
    final page = InstructorProfilePage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
