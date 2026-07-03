import 'package:coffee_bean/data/model/response/hub/instructor_info.dart';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/network/network_common.dart';
import 'package:equatable/equatable.dart';

class InstructorDetailState extends Equatable {
  final InstructorInfo? instructor;
  final DbError? error;

  const InstructorDetailState({this.instructor, this.error});

  InstructorDetailState copyWith({InstructorInfo? instructor, DbError? error}) {
    return InstructorDetailState(
      instructor: instructor ?? this.instructor,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [instructor, error];
}
