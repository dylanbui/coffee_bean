import 'package:coffee_bean/data/model/response/hub/instructor_info.dart';
import 'package:db_core/db_core.dart';

class InstructorDetailState extends BaseBlocState {
  final InstructorInfo? instructor;
  final DbError? error;

  InstructorDetailState({this.instructor, this.error});

  InstructorDetailState copyWith({InstructorInfo? instructor, DbError? error}) {
    return InstructorDetailState(
      instructor: instructor ?? this.instructor,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [instructor, error];
}
