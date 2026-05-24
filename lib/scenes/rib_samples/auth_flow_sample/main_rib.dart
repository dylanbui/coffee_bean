/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:30
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/scenes/rib_samples/auth_flow_sample/auth_flow_rib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- STATE ---
abstract class MainState extends BaseBlocState {
  final String? token;
  MainState({this.token});
  
  @override
  List<Object> get props => [token ?? ''];
}

class MainInitial extends MainState {}
class MainAuthenticated extends MainState {
  MainAuthenticated(String token) : super(token: token);
}

// --- INTERACTOR ---
class MainInteractor extends CubitInteractor<MainRouter, MainState> implements AuthFlowRibListener {
  MainInteractor(MainRouter router) : super(MainInitial(), router: router);

  void startLoginFlow() {
    // The Interactor only makes the business decision to start the flow.
    router?.startAuthFlow(this);
  }

  @override
  void onAuthFlowCompleted(String userToken) {
    emit(MainAuthenticated(userToken));
  }

  void logout() {
    emit(MainInitial());
  }
}

// --- ROUTER ---
class MainRouter extends DbNoteRouter {
  void startAuthFlow(AuthFlowRibListener listener) {
    // 1. Create the Flow Builder
    final authFlowBuilder = AuthFlowBuilder(listener: listener);

    // 2. Build the Flow Router
    final authFlowRouter = authFlowBuilder.build();

    // 3. Connect the hierarchy so child modules can navigate up
    authFlowRouter.parentRouter = this;

    // 4. MainRouter performs the push action using the Flow's initial view
    navigator.push(authFlowRouter.viewController, routeName: authFlowRouter.flowBaseRouteName);
  }
}

// --- BUILDER ---
class MainBuilder extends DbNoteBuilder<MainRouter> {
  @override
  MainRouter build() {
    final router = MainRouter();
    final interactor = MainInteractor(router);
    final page = MainPage(interactor: interactor);
    
    router.attach(interactor, page);
    return router;
  }
}

// --- PAGE ---
//ignore: must_be_immutable
class MainPage extends CubitStateFulWidget<MainInteractor, MainState> {
  // Fix: Explicitly pass interactor to super to avoid potential versioning issues with super.parameter
  MainPage({super.key, required super.interactor});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends CubitState<MainPage, MainInteractor, MainState> {
  @override
  dynamic getAppBar(BuildContext context) => "Main RIB (Manual Flow)";

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<MainInteractor, MainState>(
      bloc: interactor,
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_tree, size: 100, color: Colors.blue),
                const SizedBox(height: 20),
                if (state is MainInitial) ...[
                  const Text("Demonstrating Manual Flow Routing.", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: interactor.startLoginFlow,
                      child: const Text("START MANUAL AUTH FLOW")
                  ),
                ] else if (state is MainAuthenticated) ...[
                  const Text("Auth Completed!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Token: ${state.token}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  OutlinedButton(
                      onPressed: interactor.logout,
                      child: const Text("RESET")
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
