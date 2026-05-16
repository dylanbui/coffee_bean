/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 1/5/26 - 14:45
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/dialog_demo/interactor/dialog_demo_interactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';

//ignore: must_be_immutable
class DialogDemoPage extends BaseCubitStateFulWidget with ViewControllable {
  DialogDemoPage({super.key});

  @override
  State<DialogDemoPage> createState() => _DialogDemoPageState();
}

class _DialogDemoPageState extends BaseCubitState<DialogDemoPage, DialogDemoInteractor, DialogDemoState> {

  @override
  dynamic getAppBar(BuildContext context) => "DialogDemo";

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
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}