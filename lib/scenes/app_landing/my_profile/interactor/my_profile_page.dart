import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/my_profile_logged_in_panel.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/my_profile_logged_out_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class MyProfilePage extends CubitStateFulWidget<MyProfileInteractor, MyProfileState> {
  MyProfilePage({super.key, required super.interactor});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends CubitState<MyProfilePage, MyProfileInteractor, MyProfileState> {
  
  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: getBody(context),
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
