/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:14
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_auth_features/user_agreement/interactor/user_agreement_event_state.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_agreement/interactor/user_agreement_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class UserAgreementPage extends AppCubitStateFulWidget<UserAgreementInteractor, UserAgreementState> {
  UserAgreementPage({super.key, required super.interactor});

  @override
  State<UserAgreementPage> createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends AppCubitState<UserAgreementPage, UserAgreementInteractor, UserAgreementState> {

  @override
  String? getTitle() => "User Agreement";

  @override
  CoffeeAppBarStyleConfig getAppBarStyle() => TmLabAppBarStyle.whiteStyle;

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return wrapTapToUnfocus(
      Scaffold(
        backgroundColor: TMLabsColor.white,
        appBar: appBar,
        resizeToAvoidBottomInset: false,
        body: body,
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<UserAgreementInteractor, UserAgreementState>(
      listener: _onStateListener,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Please read and accept our terms and conditions to continue using the application.',
                style: TMLabsTextStyle.title,
              ),
              const SizedBox(height: 40),
              AppButton(
                text: "Accept and Continue",
                style: TMLabsButtonStyle.primary,
                isLoading: state is UserAgreementInProgress, // Assuming state exists
                onPressed: () {
                  // Handle accept logic
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onStateListener(BuildContext context, UserAgreementState state) {
    if (state is UserAgreementSuccess) {
      // Handle success
    } else if (state is UserAgreementError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: TMLabsColor.error),
      );
    }
  }

}
