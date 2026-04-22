/*
 * Created with IntelliJ IDEA
 * Package: commons
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 29/06/2022 - 14:16
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';

// Cách 1
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final List<Widget>? appBarActions;
  final bool hideBackButton;
  final Color backButtonColor;

  @override
  final Size preferredSize; // default is 56.0

  const CustomAppBar(this.title, {super.key, this.appBarActions, this.hideBackButton = false, this.backButtonColor = Colors.white}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Align(
          alignment: Alignment.centerLeft,
          child: Text(title, style: const TextStyle(color: Colors.white))
      ),
      titleSpacing: hideBackButton ? kTabLabelPadding.right : 0,
      automaticallyImplyLeading: !hideBackButton,
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(color: backButtonColor),
      actions: appBarActions,
    );
  }
}


// Cach 2
// ignore: must_be_immutable
class MyAppBar extends AppBar {

  final String titleBar;
  // List<Widget> appBarActions = [];
  List<Widget>? appBarActions;

  // <Widget>[
  // IconButton(
  // icon: const Icon(Icons.notifications),
  // onPressed: () => null,
  // ),
  // IconButton(
  // icon: const Icon(Icons.person),
  // onPressed: () => null,
  // ),
  // ]

  MyAppBar(this.titleBar, {super.key, this.appBarActions}) : super(iconTheme: const IconThemeData(
      color: Colors.black, //change your color here
    ),
    backgroundColor: Colors.white,
    title: Text(titleBar, style: const TextStyle(color: Colors.black),),
    elevation: 0.0,
    titleSpacing: 0,
    automaticallyImplyLeading: true,
    actions: appBarActions,
  );

}