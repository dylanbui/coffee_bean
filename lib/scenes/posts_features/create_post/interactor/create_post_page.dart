import 'package:coffee_bean/scenes/posts_features/create_post/interactor/create_post_event_state.dart';
import 'package:coffee_bean/scenes/posts_features/create_post/interactor/create_post_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_ui.dart';
import 'package:coffee_bean/shared/widget/html_editor_widget.dart';
import 'package:coffee_bean/shared/widget/image_wechat_picker_list_view.dart';
import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class CreatePostPage extends AppCubitStateFulWidget<CreatePostInteractor, CreatePostState> {
  CreatePostPage({super.key, required super.interactor});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends AppCubitState<CreatePostPage, CreatePostInteractor, CreatePostState>
    implements HtmlEditorListener {
  late final Widget _htmlEditor;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _htmlEditor = Container(
      color: Colors.white,
      child: HtmlEditorWidget(
        initialHtml: interactor.state.htmlContent,
        listener: this,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void onSaved(String html) {
    interactor.onHtmlContentChanged(html);
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocListener<CreatePostInteractor, CreatePostState>(
      listenWhen: (previous, current) => previous.failure != current.failure && current.failure != null,
      listener: (context, state) {
        if (state.failure != null) {
          context.showFlashError(state.failure!.error.message);
        }
      },
      child: BlocBuilder<CreatePostInteractor, CreatePostState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTitleInput(state),
                              const SizedBox(height: 16),
                              _buildContentPreview(context, state),
                              const SizedBox(height: 16),
                              _buildTopicSelection(context, state),
                              const SizedBox(height: 16),
                              _buildImagePicker(state),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomButtons(context, state),
                    ],
                  ),
                ),
              ),
              _buildHtmlEditorOverlay(state),
              if (state.isLoading) getLoadingView(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitleInput(CreatePostState state) {
    return AppInputField(
      controller: _titleController,
      hintText: "Nhập tiêu đề...",
      onChanged: interactor.onTitleChanged,
      errorText: state.validation.isTitleValid ? null : "Tiêu đề không được để trống",
      config: const AppInputStyleConfig(
        borderStyle: AppInputBorderStyle.underline,
      ),
    );
  }

  Widget _buildContentPreview(BuildContext context, CreatePostState state) {
    final hasError = !state.validation.isContentValid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: GestureDetector(
            onTap: () => interactor.toggleEditor(true),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasError ? Colors.red : TMLabsColor.lightGrey,
                  width: hasError ? 1.5 : 1.2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: state.htmlContent.isEmpty
                  ? const Text("Nội dung bài đăng...", style: TextStyle(color: Colors.grey))
                  : Html(data: state.htmlContent),
            ),
          ),
        ),
        if (hasError) _buildErrorMessage("Nội dung không được để trống"),
      ],
    );
  }

  Widget _buildTopicSelection(BuildContext context, CreatePostState state) {
    final hasError = !state.validation.isTopicValid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chủ đề",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: hasError ? const EdgeInsets.all(8) : EdgeInsets.zero,
          decoration: hasError
              ? BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1.2),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...state.selectedTopics.asMap().entries.map((entry) {
                return IntrinsicWidth(
                  child: AppLabel(
                    "#${entry.value.topicName}",
                    style: TMLabsTextStyle.caption.copyWith(fontSize: 11, color: TMLabsColor.grey),
                    backgroundColor: TMLabsColor.lightGrey.withValues(alpha: 0.5),
                    borderRadius: 20,
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    trailingIcon: TapEffect(
                      onTap: () => interactor.removeTopic(entry.key),
                      child: const Icon(Icons.close, size: 14, color: TMLabsColor.grey),
                    ),
                  ),
                );
              }),
              IntrinsicWidth(
                child: TapEffect(
                  onTap: () => interactor.openTopicSelection(),
                  child: AppLabel(
                    "Chọn topic",
                    style: TMLabsTextStyle.caption.copyWith(fontSize: 11, color: TMLabsColor.primary),
                    backgroundColor: Colors.transparent,
                    borderColor: TMLabsColor.primary,
                    borderRadius: 20,
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    leadingIcon: const Icon(Icons.add, size: 14, color: TMLabsColor.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError) _buildErrorMessage("Vui lòng chọn ít nhất một chủ đề"),
      ],
    );
  }

  Widget _buildImagePicker(CreatePostState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hình ảnh",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ImageWechatPickerListView(
          images: state.images,
          maxImages: 1,
          onImagesPicked: interactor.onImagesPicked,
          onRemoveImage: interactor.removeImage,
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context, CreatePostState state) {
    return AppUi.getBottomActionArea(
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: "Đóng",
              style: TMLabsButtonStyle.outline,
              onPressed: () => interactor.onClose(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: AppButton(
              text: "Tạo bài đăng",
              style: TMLabsButtonStyle.primary,
              onPressed: () {
                if (interactor.validate()) {
                  _showConfirmDialog(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHtmlEditorOverlay(CreatePostState state) {
    return IgnorePointer(
      ignoring: !state.isEditorVisible,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: state.isEditorVisible ? 1.0 : 0.0,
        child: _htmlEditor,
      ),
    );
  }

  Widget _buildErrorMessage(String? errorText) {
    if (errorText == null || errorText.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 14),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12, height: 1.2),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    FlashDialogHelper.show<bool>(
      context: context,
      title: "Xác nhận",
      content: "Bài đăng của bạn sẽ được gởi đi !",
      actions: [
        FlashDialogAction(label: "Hủy", value: false, color: Colors.grey),
        FlashDialogAction(label: "Gởi", value: true, color: TMLabsColor.primary),
      ],
    ).then((confirmed) {
      if (confirmed == true) {
        interactor.submitPost();
      }
    });
  }
}
