/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:24
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_features/privacy_policy/interactor/privacy_policy_event_state.dart';
import 'package:coffee_bean/scenes/user_features/privacy_policy/interactor/privacy_policy_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class PrivacyPolicyPage extends AppCubitStateFulWidget<PrivacyPolicyInteractor, PrivacyPolicyState> {
  PrivacyPolicyPage({super.key, required super.interactor});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends AppCubitState<PrivacyPolicyPage, PrivacyPolicyInteractor, PrivacyPolicyState> {

  @override
  String? getTitle() => "Privacy Policy";

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      backgroundColor: TMLabsColor.white,
      appBar: appBar,
      body: body,
    );
  }

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
                style: TMLabsTextStyle.body,
              ),
              const SizedBox(height: 40),
              AppButton(
                text: "Close",
                style: TMLabsButtonStyle.outline,
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

}
