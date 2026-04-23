import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget with ViewControllable {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Trang cộng đồng !!!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
