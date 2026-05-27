import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/my_profile_logged_in_panel.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/my_profile_logged_out_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class MyProfilePage extends AppCubitStateFulWidget<MyProfileInteractor, MyProfileState> {
  MyProfilePage({super.key, required super.interactor});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends AppCubitState<MyProfilePage, MyProfileInteractor, MyProfileState> {

  @override
  String? getTitle() => null;

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: appBar,
      body: body,
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<MyProfileInteractor, MyProfileState>(
      bloc: interactor,
      builder: (context, state) {
        if (state.isLoggedIn) {
          return MyProfileLoggedInPanel(interactor: interactor);
        }
        return MyProfileLoggedOutPanel(interactor: interactor);
      },
    );
  }
}
