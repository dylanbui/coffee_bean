import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/my_profile_logged_in_member_panel.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/my_profile_logged_out_member_panel.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
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
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: TMLabsColor.bgTabbarWhile,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: TMLabsColor.bgMain,
      appBar: appBar,
      body: body,
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<MyProfileInteractor, MyProfileState>(
      bloc: interactor,
      builder: (context, state) {
        return MyProfileLoggedInMemberPanel(interactor: interactor);
        // if (state.isLoggedIn) {
        //   return MyProfileLoggedInMemberPanel(interactor: interactor);
        // }
        // return MyProfileLoggedOutMemberPanel(interactor: interactor);
      },
    );
  }
}
