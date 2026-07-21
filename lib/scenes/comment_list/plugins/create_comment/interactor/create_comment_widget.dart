import 'package:coffee_bean/scenes/comment_list/plugins/create_comment/interactor/create_comment_event_state.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/create_comment/interactor/create_comment_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/base/tap_to_unfocus_mixin.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_input_configs.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:coffee_bean/utils/flash_utils/flash_toast_helper.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/utils/app_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCommentWidget extends AppCubitStateFulWidget<CreateCommentInteractor, CreateCommentState> {
  CreateCommentWidget({super.key, required super.interactor});

  @override
  State<CreateCommentWidget> createState() => _CreateCommentWidgetState();
}

class _CreateCommentWidgetState extends AppCubitState<CreateCommentWidget, CreateCommentInteractor, CreateCommentState> with TapToUnfocusMixin {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  String? getTitle() => null;

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return wrapTapToUnfocus(body);
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<CreateCommentInteractor, CreateCommentState>(
      listenWhen: (previous, current) => previous.failure != current.failure,
      listener: (context, state) {
        if (state.content.isEmpty && _controller.text.isNotEmpty) {
          _controller.clear();
        }
        if (state.failure != null) {
          context.showFlashError(state.failure!.error.message);
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: TMLabsColor.lightGrey.withValues(alpha: 0.5))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AppInputField(
                  controller: _controller,
                  autofocus: interactor.autoFocus,
                  config: CoffeeInputStyles.filled.copyWith(
                    isDense: true,
                    borderRadius: 24,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  hintText: "Viết bình luận...",
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 500,
                  onChanged: interactor.onContentChanged,
                ),
              ),
              const SizedBox(width: 8),
              _buildSendButton(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSendButton(CreateCommentState state) {
    final bool canSend = state.content.trim().isNotEmpty && !state.isSending;

    return state.isSending
        ? const SizedBox(
            width: 44,
            height: 44,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: TMLabsColor.primary,
              ),
            ),
          )
        : IconButton(
            onPressed: canSend ? interactor.sendComment : null,
            icon: Icon(
              Icons.send_rounded,
              color: canSend ? TMLabsColor.primary : TMLabsColor.lightGrey,
            ),
          );
  }
}
