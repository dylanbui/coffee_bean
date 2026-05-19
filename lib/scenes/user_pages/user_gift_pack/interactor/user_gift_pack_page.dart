/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 23:22
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_pages/user_gift_pack/interactor/user_gift_pack_event_state.dart';
import 'package:coffee_bean/scenes/user_pages/user_gift_pack/interactor/user_gift_pack_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';

//ignore: must_be_immutable
class UserGiftPackPage extends CubitStateFulWidget<UserGiftPackInteractor, UserGiftPackState> {
  UserGiftPackPage({super.key, required super.interactor});

  @override
  State<UserGiftPackPage> createState() => _UserGiftPackPageState();
}

class _UserGiftPackPageState extends CubitState<UserGiftPackPage, UserGiftPackInteractor, UserGiftPackState> {

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    // Tùy chỉnh Scaffold với extendBodyBehindAppBar
    return BlocProvider.value(
      value: interactor,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Newcomer Gift Pack",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: getBody(context),
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<UserGiftPackInteractor, UserGiftPackState>(
      listener: _onStateListener,
      builder: (context, state) => _buildMainContent(context, state),
    );
  }

  // region UI Builders

  void _onStateListener(BuildContext context, UserGiftPackState state) {
    if (state is UserGiftPackInProgress) {
      showLoading();
    } else {
      hideLoading();
      if (state is UserGiftPackSuccess) {
        // Xử lý thành công
      } else if (state is UserGiftPackError) {
        _showError(state.message);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildMainContent(BuildContext context, UserGiftPackState state) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF2EFED), // Màu nền giống trong hình
        // Nếu có hình nền, bạn có thể dùng:
        // image: DecorationImage(image: AssetImage("assets/images/gift_pack_bg.png"), fit: BoxFit.cover),
      ),
      child: SafeArea(
        top: false, // Để background tràn lên status bar
        child: Column(
          children: [
            const Spacer(flex: 3),
            _buildCenterContent(),
            const Spacer(flex: 4),
            _buildBottomButtons(state),
            const SizedBox(height: 20), // Cách cạnh dưới 20px
          ],
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Graphic hình tròn ở giữa
        Container(
          width: 160,
          height: 160,
          decoration: const BoxDecoration(
            color: Color(0xFFF9D9CD),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          "Congratulations! You've received a Newcomer Gift Pack",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            "(Bonus points or coupons, current popup is a background illustration)",
            style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(UserGiftPackState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          AppButton(
            text: "View Gift Pack",
            isLoading: state is UserGiftPackInProgress,
            onPressed: () => _handleButtonClick("View Gift Pack"),
          ),
          const SizedBox(height: 10), // Cách nhau 10px
          AppButton(
            text: "Back",
            style: TMLabsStyle.outlineButton,
            onPressed: () => _handleButtonClick("Back"),
          ),
        ],
      ),
    );
  }

  // endregion

  // region Logic Handlers

  void _handleButtonClick(String buttonName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You clicked: $buttonName"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // endregion
}
