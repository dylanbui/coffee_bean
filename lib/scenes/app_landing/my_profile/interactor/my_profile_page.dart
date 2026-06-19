import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/my_profile_logged_in_member_panel.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/widget/my_profile_logged_out_panel.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/interactor/my_profile_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/app_action_check_in_button.dart';
import 'package:coffee_bean/shared/ui_control/coffee_app_bar.dart';
import 'package:db_core/utils/app_button.dart';
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
    return CoffeeAppBar(
      style: TmLabAppBarStyle.whiteStyle.copyWith(
        leadingWidth: 120,
      ),
      hideBackButton: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: AppButton(
            text: 'Tôi',
            width: null, // Bỏ fixed width
            height: 40,
            mainAxisSize: MainAxisSize.min,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            style: TMLabsButtonStyle.primary.copyWith(
              borderRadius: 20,
            ),
            leftIcon: AppIcon(AppAssets.icons.icMyFill, color: Colors.white, size: 20),
            onPressed: () => interactor.goToUpdateProfile(),
          ),
        ),
      ),
      actions: [
        BlocBuilder<MyProfileInteractor, MyProfileState>(
          bloc: interactor,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: AppActionCheckInButton(
                isCheckedIn: state.isCheckedIn,
                onTap: () => interactor.doDailySignIn(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return BlocBuilder<MyProfileInteractor, MyProfileState>(
      bloc: interactor,
      buildWhen: (p, c) => p.isLoggedIn != c.isLoggedIn,
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: TMLabsColor.bgMain,
          // Re-evaluate AppBar whenever isLoggedIn changes
          appBar: state.isLoggedIn ? getAppBar(context) : null,
          body: body,
        );
      },
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<MyProfileInteractor, MyProfileState>(
      bloc: interactor,
      builder: (context, state) {
        if (state.isLoggedIn) {
          return MyProfileLoggedInMemberPanel(interactor: interactor);
        }
        return MyProfileLoggedOutPanel(interactor: interactor);
      },
    );
  }
}
