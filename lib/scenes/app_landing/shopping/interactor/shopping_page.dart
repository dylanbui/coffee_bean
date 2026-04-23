import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget with ViewControllable {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Mua sắm nè !!!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
