/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 */

import 'package:coffee_bean/scenes/user_auth_features/app_agreement/interactor/app_agreement_event_state.dart';
import 'package:coffee_bean/scenes/user_auth_features/app_agreement/interactor/app_agreement_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

//ignore: must_be_immutable
class AppAgreementPage extends AppCubitStateFulWidget<AppAgreementInteractor, AppAgreementState> {
  final String initialTitle;
  AppAgreementPage({super.key, required super.interactor, required this.initialTitle});

  @override
  State<AppAgreementPage> createState() => _AppAgreementPageState();
}

class _AppAgreementPageState extends AppCubitState<AppAgreementPage, AppAgreementInteractor, AppAgreementState> {

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) => null;

  @override
  bool get tapToUnfocus => true;

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return wrapTapToUnfocus(
      Scaffold(
        backgroundColor: TMLabsColor.white,
        body: SafeArea(child: body),
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<AppAgreementInteractor, AppAgreementState>(
      listener: _onStateListener,
      builder: (context, state) {
        String htmlContent = "";
        String title = widget.initialTitle;
        if (state is AppAgreementSuccess) {
          htmlContent = state.data['content']?.toString() ?? "";
          title = state.data['title']?.toString() ?? widget.initialTitle;
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10.0, 32.0, 16.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state is AppAgreementInProgress)
                      getLoadingView()
                    else ...[
                      Text(
                        title,
                        style: TMLabsTextStyle.title.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (htmlContent.isNotEmpty)
                        Html(data: htmlContent)
                      else if (state is! AppAgreementInitial)
                        getEmptyItemView(caption: "Không có nội dung điều khoản"),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppButton(
                text: "Đóng",
                style: TMLabsButtonStyle.outline,
                onPressed: () => interactor.router?.pop(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onStateListener(BuildContext context, AppAgreementState state) {
    if (state is AppAgreementError) {
      context.showFlashError(state.message);
    }
  }
}
