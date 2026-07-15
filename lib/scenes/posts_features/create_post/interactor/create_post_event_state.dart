import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:db_core/db_core.dart';

class CreatePostFormStatus extends Equatable {
  final bool isTitleValid;
  final bool isContentValid;
  final bool isTopicValid;

  const CreatePostFormStatus({
    this.isTitleValid = true,
    this.isContentValid = true,
    this.isTopicValid = true,
  });

  bool get hasError => !isTitleValid || !isContentValid || !isTopicValid;

  @override
  List<Object?> get props => [isTitleValid, isContentValid, isTopicValid];

  CreatePostFormStatus copyWith({
    bool? isTitleValid,
    bool? isContentValid,
    bool? isTopicValid,
  }) {
    return CreatePostFormStatus(
      isTitleValid: isTitleValid ?? this.isTitleValid,
      isContentValid: isContentValid ?? this.isContentValid,
      isTopicValid: isTopicValid ?? this.isTopicValid,
    );
  }
}

class CreatePostState extends BaseBlocState {
  final bool isLoading;
  final String title;
  final String htmlContent;
  final List<HotTopic> selectedTopics;
  final List<String> images;
  final bool isEditorVisible;
  final DbFailure? failure;
  final bool isSubmitting;
  final CreatePostFormStatus validation;

  CreatePostState({
    this.isLoading = false,
    this.title = '',
    this.htmlContent = '',
    this.selectedTopics = const [],
    this.images = const [],
    this.isEditorVisible = false,
    this.failure,
    this.isSubmitting = false,
    this.validation = const CreatePostFormStatus(),
  });

  @override
  List<Object?> get props => [
        isLoading,
        title,
        htmlContent,
        selectedTopics,
        images,
        isEditorVisible,
        failure,
        isSubmitting,
        validation,
      ];

  CreatePostState copyWith({
    bool? isLoading,
    String? title,
    String? htmlContent,
    List<HotTopic>? selectedTopics,
    List<String>? images,
    bool? isEditorVisible,
    DbFailure? failure,
    bool? isSubmitting,
    CreatePostFormStatus? validation,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      title: title ?? this.title,
      htmlContent: htmlContent ?? this.htmlContent,
      selectedTopics: selectedTopics ?? this.selectedTopics,
      images: images ?? this.images,
      isEditorVisible: isEditorVisible ?? this.isEditorVisible,
      failure: failure ?? this.failure,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      validation: validation ?? this.validation,
    );
  }
}
