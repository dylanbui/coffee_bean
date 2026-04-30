import 'package:equatable/equatable.dart';

abstract class ProblemReportState extends Equatable {
  final String text;
  final List<String> images;
  
  const ProblemReportState({this.text = '', this.images = const []});

  @override
  List<Object?> get props => [text, images];
}

class ProblemReportInitial extends ProblemReportState {
  const ProblemReportInitial() : super();
}

class ProblemReportUpdate extends ProblemReportState {
  const ProblemReportUpdate({super.text, super.images});
}

class ProblemReportSubmitting extends ProblemReportState {
  const ProblemReportSubmitting({super.text, super.images});
}

class ProblemReportSuccess extends ProblemReportState {
  const ProblemReportSuccess() : super();
}

class ProblemReportError extends ProblemReportState {
  final String message;
  const ProblemReportError(this.message, {super.text, super.images});

  @override
  List<Object?> get props => [...super.props, message];
}
