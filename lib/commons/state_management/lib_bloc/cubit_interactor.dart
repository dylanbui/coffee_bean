/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 26/08/2022 - 16:13
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef CubitInteractor<T extends DbNoteRoutable, State> = CubitPresenterInteractor<T, DbNoteEmptyPresenter, State>;

abstract class CubitPresenterInteractor<T extends DbNoteRoutable, P extends DbNotePresentable, State> extends Cubit<State> implements DbNoteInteractor<T, P> {

  @override
  T? router;

  @override
  P? presenter;

  CubitPresenterInteractor(super.initialState, {this.router, this.presenter});

  // void pop() {
  //   // router?.pop();
  // }

}
