import 'dart:io';
import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/data/model/request/hub/create_post_request.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/data/repository/infra_repository.dart';
import 'package:coffee_bean/scenes/app_landing/topic_selection/topic_selection_builder.dart';
import 'package:coffee_bean/scenes/posts_features/create_post/create_post_builder.dart';
import 'package:coffee_bean/scenes/posts_features/create_post/interactor/create_post_event_state.dart';
import 'package:coffee_bean/utils/image_utils.dart';
import 'package:db_core/db_core.dart';

class CreatePostInteractor extends CubitInteractor<CreatePostRoutable, CreatePostState>
    implements TopicSelectionListener {
  final HubRepository _hubRepository = locator.get<HubRepository>();
  final InfraRepository _infraRepository = locator.get<InfraRepository>();

  CreatePostInteractor(CreatePostRoutable router) : super(CreatePostState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _initData();
  }

  void _initData() {
    final defaultTopicTags = AppPrefs().getTopicInterested();

    dLog("DEBUG: AppPrefs().getTopicInterested() count: ${defaultTopicTags.length}");
    dLog("DEBUG: AppPrefs().getTopicInterested() values: $defaultTopicTags");

    // Chuyển đổi String tags thành HotTopic objects
    final initialTopics = defaultTopicTags.map((tag) => HotTopic(id: 0, topicName: tag)).toList();
    
    emit(state.copyWith(
      selectedTopics: initialTopics,
    ));
  }

  void onTitleChanged(String title) {
    emit(state.copyWith(
      title: title,
      validation: state.validation.copyWith(isTitleValid: true),
    ));
  }

  void onHtmlContentChanged(String content) {
    emit(state.copyWith(
      htmlContent: content,
      isEditorVisible: false,
      validation: state.validation.copyWith(isContentValid: true),
    ));
  }

  void toggleEditor(bool visible) {
    emit(state.copyWith(isEditorVisible: visible));
  }

  void onImagesPicked(List<String> paths) {
    final newImages = List<String>.from(state.images)..addAll(paths);
    emit(state.copyWith(images: newImages));
  }

  void removeImage(int index) {
    final newImages = List<String>.from(state.images)..removeAt(index);
    emit(state.copyWith(images: newImages));
  }

  void removeTopic(int index) {
    final newTopics = List<HotTopic>.from(state.selectedTopics)..removeAt(index);
    emit(state.copyWith(
      selectedTopics: newTopics,
      validation: state.validation.copyWith(isTopicValid: newTopics.isNotEmpty),
    ));
  }

  void openTopicSelection() {
    router?.pushTopicSelection(this);
  }

  @override
  void onTopicSelectionFinish(List<HotTopic>? selected) {
    if (selected == null || selected.isEmpty) return;

    final currentTopics = List<HotTopic>.from(state.selectedTopics);
    for (var topic in selected) {
      if (!currentTopics.any((t) => t.topicName == topic.topicName)) {
        currentTopics.add(topic);
      }
    }
    emit(state.copyWith(
      selectedTopics: currentTopics,
      validation: state.validation.copyWith(isTopicValid: true),
    ));
  }

  bool validate() {
    final status = CreatePostFormStatus(
      isTitleValid: state.title.trim().isNotEmpty,
      isContentValid: state.htmlContent.trim().isNotEmpty && state.htmlContent != "<p></p>",
      isTopicValid: state.selectedTopics.isNotEmpty,
    );

    emit(state.copyWith(validation: status));
    return !status.hasError;
  }

  Future<void> submitPost() async {
    if (!validate()) return;

    emit(state.copyWith(isSubmitting: true, isLoading: true));

    // 1. Upload images in parallel
    List<String> uploadedUrls = [];
    if (state.images.isNotEmpty) {
      final uploadTasks = state.images.map((path) => _infraRepository.uploadFile(File(path), directory: 'post'));
      final results = await Future.wait(uploadTasks);

      for (var result in results) {
        if (result case DbSuccess(data: final url)) {
          uploadedUrls.add(url);
        }
      }
    }

    // 2. Create post
    final request = CreatePostRequest(
      postTitle: state.title,
      postContent: state.htmlContent,
      topicTags: state.selectedTopics.map((e) => e.topicName ?? '').where((e) => e.isNotEmpty).toList(),
      postCover: uploadedUrls.isNotEmpty ? uploadedUrls.first : "",
    );

    final result = await _hubRepository.createPost(request);
    
    emit(state.copyWith(isSubmitting: false, isLoading: false));

    if (result case DbSuccess()) {
      router?.pop();
    } else if (result case DbFailure(:final error)) {
      emit(state.copyWith(failure: DbFailure(error)));
    }
  }

  void onClose() {
    router?.pop();
  }
}
