import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget with ViewControllable {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Trang chủ tui ne !",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
