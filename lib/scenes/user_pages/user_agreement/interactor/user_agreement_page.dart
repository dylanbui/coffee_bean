/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:14
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_pages/user_agreement/interactor/user_agreement_event_state.dart';
import 'package:coffee_bean/scenes/user_pages/user_agreement/interactor/user_agreement_interactor.dart';
import 'package:coffee_bean/shared/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';

//ignore: must_be_immutable
class UserAgreementPage extends CubitStateFulWidget<UserAgreementInteractor, UserAgreementState> {
  UserAgreementPage({super.key, required super.interactor});

  @override
  State<UserAgreementPage> createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends CubitState<UserAgreementPage, UserAgreementInteractor, UserAgreementState> {

  @override
  dynamic getAppBar(BuildContext context) => "User Agreement";

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
              AppButton.primary(
                text: "Accept and Continue",
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
