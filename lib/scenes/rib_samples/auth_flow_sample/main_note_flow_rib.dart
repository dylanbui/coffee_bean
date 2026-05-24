/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 16:30
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/scenes/rib_samples/auth_flow_sample/auth_note_flow_rib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- STATE ---
abstract class MainNoteFlowState extends BaseBlocState {
  final String? token;
  MainNoteFlowState({this.token});
  
  @override
  List<Object> get props => [token ?? ''];
}

class MainNoteFlowInitial extends MainNoteFlowState {}
class MainNoteFlowAuthenticated extends MainNoteFlowState {
  MainNoteFlowAuthenticated(String token) : super(token: token);
}

// --- INTERACTOR ---
class MainNoteFlowInteractor extends CubitInteractor<MainNoteFlowRouter, MainNoteFlowState> implements AuthNoteFlowListener {
  MainNoteFlowInteractor(MainNoteFlowRouter router) : super(MainNoteFlowInitial(), router: router);

  void startLoginFlow() {
    // Decision to start the flow
    router?.startAuthFlow(this);
  }

  @override
  void onAuthFlowCompleted(String userToken) {
    emit(MainNoteFlowAuthenticated(userToken));
  }

  @override
  void onAuthFlowCancelled() {
    // Handle cancellation (User pressed back on first page of flow)
  }

  void logout() {
    emit(MainNoteFlowInitial());
  }
}

// --- ROUTER ---
class MainNoteFlowRouter extends DbNoteRouter {
  void startAuthFlow(AuthNoteFlowListener listener) {
    // 1. Create the Unified Flow
    final authFlow = AuthNoteFlow();

    // 2. Start the flow. 
    // AuthNoteFlow handles its own internal routing and lifecycle.
    authFlow.start(this, listener);
  }
}

// --- BUILDER ---
class MainNoteFlowBuilder extends DbNoteBuilder<MainNoteFlowRouter> {
  @override
  MainNoteFlowRouter build() {
    final router = MainNoteFlowRouter();
    final interactor = MainNoteFlowInteractor(router);
    final page = MainNoteFlowPage(interactor: interactor);
    
    router.attach(interactor, page);
    return router;
  }
}

// --- PAGE ---
//ignore: must_be_immutable
class MainNoteFlowPage extends CubitStateFulWidget<MainNoteFlowInteractor, MainNoteFlowState> {
  MainNoteFlowPage({super.key, required super.interactor});

  @override
  State<MainNoteFlowPage> createState() => _MainNoteFlowPageState();
}

class _MainNoteFlowPageState extends CubitState<MainNoteFlowPage, MainNoteFlowInteractor, MainNoteFlowState> {
  @override
  dynamic getAppBar(BuildContext context) => "Main RIB (DbNoteFlow)";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<MainNoteFlowInteractor, MainNoteFlowState>(
      bloc: interactor,
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.waves, size: 100, color: Colors.purple),
                const SizedBox(height: 20),
                if (state is MainNoteFlowInitial) ...[
                  const Text("Demonstrating DbNoteFlow (Unified Flow).", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: interactor.startLoginFlow,
                      child: const Text("START UNIFIED FLOW")
                  ),
                ] else if (state is MainNoteFlowAuthenticated) ...[
                  const Text("Welcome Back!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Token: ${state.token}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  OutlinedButton(
                      onPressed: interactor.logout,
                      child: const Text("LOGOUT")
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
