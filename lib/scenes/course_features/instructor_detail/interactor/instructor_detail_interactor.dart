import 'package:coffee_bean/data/repository/course_repository.dart';
import 'package:coffee_bean/scenes/course_features/instructor_detail/instructor_detail_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/course_features/instructor_detail/interactor/instructor_detail_event_state.dart';

class InstructorDetailInteractor extends CubitInteractor<InstructorDetailRoutable, InstructorDetailState> {
  final int instructorId;
  final CourseRepository _courseRepository = locator<CourseRepository>();

  InstructorDetailInteractor(InstructorDetailRoutable router, {required this.instructorId,}) : super(const InstructorDetailState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadInstructorDetail();
  }

  Future<void> _loadInstructorDetail() async {
    final result = await _courseRepository.getInstructorById(instructorId);
    if (result case DbSuccess(:final data)) {
      emit(state.copyWith(instructor: data));
    } else if (result case DbFailure(:final error)) {
      emit(state.copyWith(error: error));
    }
  }
}
