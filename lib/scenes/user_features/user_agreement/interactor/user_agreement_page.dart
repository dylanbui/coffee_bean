/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:14
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_features/user_agreement/interactor/user_agreement_event_state.dart';
import 'package:coffee_bean/scenes/user_features/user_agreement/interactor/user_agreement_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar_ext.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';

//ignore: must_be_immutable
class UserAgreementPage extends CubitStateFulWidget<UserAgreementInteractor, UserAgreementState> {
  UserAgreementPage({super.key, required super.interactor});

  @override
  State<UserAgreementPage> createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends CubitState<UserAgreementPage, UserAgreementInteractor, UserAgreementState> {

  @override
  dynamic getAppBar(BuildContext context) => coffeeAppBar("User Agreement");

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    var appBar = getAppBar(context);

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
    return BlocConsumer<UserAgreementInteractor, UserAgreementState>(
      listener: _onStateListener,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Please read and accept our terms and conditions to continue using the application.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              AppButton(
                text: "Accept and Continue",
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
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

}
