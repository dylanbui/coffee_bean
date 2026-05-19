/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:24
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/custom_app_bar.dart';
import 'package:coffee_bean/scenes/user_features/privacy_policy/interactor/privacy_policy_event_state.dart';
import 'package:coffee_bean/scenes/user_features/privacy_policy/interactor/privacy_policy_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';

//ignore: must_be_immutable
class PrivacyPolicyPage extends CubitStateFulWidget<PrivacyPolicyInteractor, PrivacyPolicyState> {
  PrivacyPolicyPage({super.key, required super.interactor});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends CubitState<PrivacyPolicyPage, PrivacyPolicyInteractor, PrivacyPolicyState> {

  @override
  dynamic getAppBar(BuildContext context) => "Privacy Policy";

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
        body: getBody(context),
      ),
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              AppButton(
                text: "Close",
                style: TMLabsStyle.outlineButton,
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
