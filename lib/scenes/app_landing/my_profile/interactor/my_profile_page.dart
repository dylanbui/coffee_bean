import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget with ViewControllable {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar("My profile", hideBackButton: true),
      body: Center(
        child: Text(
          "Thông tin về tôi",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
