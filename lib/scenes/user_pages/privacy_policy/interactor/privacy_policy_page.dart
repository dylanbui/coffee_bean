/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:24
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_pages/privacy_policy/interactor/privacy_policy_event_state.dart';
import 'package:coffee_bean/scenes/user_pages/privacy_policy/interactor/privacy_policy_interactor.dart';
import 'package:coffee_bean/shared/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/base_cubit_statefull_widget.dart';

//ignore: must_be_immutable
class PrivacyPolicyPage extends BaseCubitStateFulWidget with ViewControllable {
  PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends BaseCubitState<PrivacyPolicyPage, PrivacyPolicyInteractor, PrivacyPolicyState> {

  @override
  dynamic getAppBar(BuildContext context) => "Privacy Policy";

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<PrivacyPolicyInteractor, PrivacyPolicyState>(
      listener: _onStateListener,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Privacy Policy Content",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              AppButton.secondary(
                text: "Close",
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onStateListener(BuildContext context, PrivacyPolicyState state) {
    if (state is PrivacyPolicySuccess) {
      // Handle success
    } else if (state is PrivacyPolicyError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

}
