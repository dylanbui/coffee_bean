/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 17:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_features/set_password/interactor/set_password_event_state.dart';
import 'package:coffee_bean/scenes/user_features/set_password/interactor/set_password_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/widget/password_field.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class SetPasswordPage extends AppCubitStateFulWidget<SetPasswordInteractor, SetPasswordState> {
  SetPasswordPage({super.key, required super.interactor});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends AppCubitState<SetPasswordPage, SetPasswordInteractor, SetPasswordState> {
  final _setPasswordController = SetPasswordController();

  @override
  void dispose() {
    _setPasswordController.dispose();
    super.dispose();
  }

  @override
  String? getTitle() => "Set Password";

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      backgroundColor: TMLabsColor.white,
      appBar: appBar,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: body,
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<SetPasswordInteractor, SetPasswordState>(
      listener: _onStateListener,
      builder: (context, state) => _buildMainContent(context, state),
    );
  }

  // region UI Builders

  void _onStateListener(BuildContext context, SetPasswordState state) {
    if (state is SetPasswordInProgress) {
      showLoading(); // Removed to use button loading
    } else {
      hideLoading();
      if (state is SetPasswordSuccess) {
        // Handle success
      } else if (state is SetPasswordError) {
        _showError(state.message);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: TMLabsColor.error));
  }

  Widget _buildMainContent(BuildContext context, SetPasswordState state) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildInputs(),
                const SizedBox(height: 40),
                AppButton(text: "Set Password", isLoading: state is SetPasswordInProgress, onPressed: _handleSubmit),
                const Spacer(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Set New Password", style: TMLabsTextStyle.h1),
        const SizedBox(height: 8),
        Text(
          "Please enter your new password to continue.",
          style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
        ),
      ],
    );
  }

  Widget _buildInputs() {
    return PasswordField(controller: _setPasswordController.passwordController, hint: "Enter Password");
  }

  // endregion

  // region Logic Handlers

  void _handleSubmit() {
    _setPasswordController.validateSetPassword(interactor, _showError);
  }

  // endregion
}

class SetPasswordController {
  final passwordController = TextEditingController();

  void validateSetPassword(SetPasswordInteractor interactor, Function(String) onError) {
    if (passwordController.text.isEmpty) {
      onError("Please enter password");
      return;
    }
    if (passwordController.text.length < 6) {
      onError("Password must be at least 6 characters");
      return;
    }
    interactor.doSetPassword(passwordController.text);
  }

  void dispose() {
    passwordController.dispose();
  }
}
