/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 17:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/custom_app_bar.dart';
import 'package:coffee_bean/scenes/user_pages/set_password/interactor/set_password_event_state.dart';
import 'package:coffee_bean/scenes/user_pages/set_password/interactor/set_password_interactor.dart';
import 'package:coffee_bean/shared/widget/password_field.dart';
import 'package:coffee_bean/shared/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';

//ignore: must_be_immutable
class SetPasswordPage extends CubitStateFulWidget<SetPasswordInteractor, SetPasswordState> {
  SetPasswordPage({super.key, required super.interactor});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends CubitState<SetPasswordPage, SetPasswordInteractor, SetPasswordState> {
  final _setPasswordController = SetPasswordController();

  @override
  void dispose() {
    _setPasswordController.dispose();
    super.dispose();
  }

  @override
  dynamic getAppBar(BuildContext context) => "Set Password";

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    var appBar = getAppBar(context);
    if (appBar is String) {
      appBar = CustomAppBar(appBar, appBarActions: getAppBarAction());
    }

    if (widget.showAppBar == false) {
      appBar = null;
    }

    return BlocProvider.value(
      value: interactor,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar as PreferredSizeWidget?,
        resizeToAvoidBottomInset: false,
        body: getBody(context),
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
      // showLoading(); // Removed to use button loading
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildMainContent(BuildContext context, SetPasswordState state) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CustomScrollView(
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
                  AppButton(
                    text: "Change Password",
                    isLoading: state is SetPasswordInProgress,
                    onPressed: _handleSubmit,
                  ),
                  const Spacer(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Set New Password",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Please enter your new password to continue.",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInputs() {
    return PasswordField(
      controller: _setPasswordController.passwordController,
      hint: "Enter Password",
    );
  }

  // endregion

  // region Logic Handlers

  void _handleSubmit() {
    _setPasswordController.validateSetPassword(
      interactor,
      _showError,
    );
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
    // interactor.doSetPassword(passwordController.text);
  }

  void dispose() {
    passwordController.dispose();
  }
}
