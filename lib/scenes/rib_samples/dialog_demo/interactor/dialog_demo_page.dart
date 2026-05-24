import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_interactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';

//ignore: must_be_immutable
class DialogDemoPage extends CubitStateFulWidget<DialogDemoInteractor, DialogDemoState> {
  DialogDemoPage({super.key, required super.interactor});

  @override
  State<DialogDemoPage> createState() => _DialogDemoPageState();
}

class _DialogDemoPageState extends CubitState<DialogDemoPage, DialogDemoInteractor, DialogDemoState> {

  @override
  dynamic getAppBar(BuildContext context) => "Dialog Demo";

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<DialogDemoInteractor, DialogDemoState>(
      listener: (context, state) {
        if (state is DialogDemoSuccess) {

        } else if (state is DialogDemoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text("Dialog Demo Content"),
            ],
          ),
        );
      },
    );
  }
}
